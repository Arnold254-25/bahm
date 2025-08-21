const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const { Pool } = require('pg');
const admin = require('./config/firebase'); // Use our custom firebase config
const bcrypt = require('bcrypt');
const { v4: uuidv4 } = require('uuid');
const winston = require('winston');
const { check, validationResult } = require('express-validator');
const Stripe = require('stripe');
const crypto = require('crypto');
require('dotenv').config();

const app = express();
const stripe = Stripe(process.env.STRIPE_SECRET_KEY);

// Logger setup
const logger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  transports: [new winston.transports.File({ filename: 'combined.log' })],
});

// PostgreSQL setup
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100,
}));

// Verify Firebase token
const verifyToken = async (req, res, next) => {
  const token = req.headers.authorization?.split('Bearer ')[1];
  if (!token) return res.status(401).json({ error: 'No token provided' });
  try {
    const decoded = await admin.auth().verifyIdToken(token);
    req.user = decoded;
    next();
  } catch (error) {
    logger.error('Token verification failed:', error);
    res.status(401).json({ error: 'Invalid token' });
  }
};

// Set PIN
app.post('/api/users/set-pin', verifyToken, [
  check('pin').isLength({ min: 4, max: 4 }).isNumeric(),
  check('phone_number').isMobilePhone('any'),
], async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });

  const { pin, phone_number } = req.body;
  const { uid } = req.user;

  try {
    const pinHash = await bcrypt.hash(pin, 10);
    const query = `
      INSERT INTO users (user_id, phone_number, pin_hash)
      VALUES ($1, $2, $3)
      ON CONFLICT (user_id)
      DO UPDATE SET pin_hash = EXCLUDED.pin_hash, phone_number = EXCLUDED.phone_number
      RETURNING *;
    `;
    const result = await pool.query(query, [uid, phone_number, pinHash]);
    logger.info(`PIN set for user ${uid}`);
    res.status(200).json({ message: 'PIN set successfully', user: result.rows[0] });
  } catch (error) {
    logger.error('Error setting PIN:', error);
    res.status(500).json({ error: 'Failed to set PIN' });
  }
});

// Link bank account
app.post('/api/bank-accounts', verifyToken, [
  check('bank_name').notEmpty(),
  check('account_number').notEmpty(),
], async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });

  const { bank_name, account_number } = req.body;
  const { uid, email } = req.user;

  try {
    // Create Stripe customer
    const customer = await stripe.customers.create({
      email,
      metadata: { firebase_uid: uid },
    });

    // In production, use Stripe Setup Intents to collect bank details securely
    const setupIntent = await stripe.setupIntents.create({
      customer: customer.id,
      payment_method_types: ['card'], // Adjust for bank transfers (e.g., 'sepa_debit' or 'ach_credit_transfer')
    });

    // Encrypt account number
    const encryptedAccountNumber = await pool.query(
      'SELECT pgp_sym_encrypt($1, $2) AS encrypted',
      [account_number, process.env.JWT_SECRET]
    );

    const query = `
      INSERT INTO bank_accounts (user_id, bank_name, account_number, stripe_customer_id, stripe_payment_method_id)
      VALUES ($1, $2, $3, $4, $5)
      RETURNING *;
    `;
    const result = await pool.query(query, [uid, bank_name, encryptedAccountNumber.rows[0].encrypted, customer.id, setupIntent.id]);
    logger.info(`Bank account linked for user ${uid}`);
    res.status(200).json({ message: 'Bank account linked', bank_account: result.rows[0], client_secret: setupIntent.client_secret });
  } catch (error) {
    logger.error('Error linking bank account:', error);
    res.status(500).json({ error: 'Failed to link bank account' });
  }
});

// Bank-to-wallet deposit
app.post('/api/transactions/deposit', verifyToken, [
  check('amount').isFloat({ min: 0.01 }),
  check('bank_account_id').isUUID(),
  check('pin').isLength({ min: 4, max: 4 }).isNumeric(),
], async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });

  const { amount, bank_account_id, pin } = req.body;
  const { uid } = req.user;

  try {
    // Verify PIN
    const user = await pool.query('SELECT pin_hash FROM users WHERE user_id = $1', [uid]);
    if (!user.rows[0]) return res.status(404).json({ error: 'User not found' });
    const pinMatch = await bcrypt.compare(pin, user.rows[0].pin_hash);
    if (!pinMatch) return res.status(401).json({ error: 'Invalid PIN' });

    // Verify bank account
    const bankAccount = await pool.query('SELECT * FROM bank_accounts WHERE bank_account_id = $1 AND user_id = $2', [bank_account_id, uid]);
    if (!bankAccount.rows[0]) return res.status(404).json({ error: 'Bank account not found' });

    // Create Stripe Payment Intent
    const paymentIntent = await stripe.paymentIntents.create({
      amount: Math.round(amount * 100), // Convert to cents
      currency: 'kes',
      customer: bankAccount.rows[0].stripe_customer_id,
      payment_method: bankAccount.rows[0].stripe_payment_method_id,
      off_session: true,
      confirm: true,
    });

    // Start transaction
    const client = await pool.connect();
    try {
      await client.query('BEGIN');

      // Record transaction
      const query = `
        INSERT INTO transactions (transaction_id, sender_id, amount, currency_code, transaction_type, status, stripe_payment_intent_id, description)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
        RETURNING *;
      `;
      const transactionId = uuidv4();
      const result = await client.query(query, [transactionId, uid, amount, 'KES', 'BANK_DEPOSIT', 'PENDING', paymentIntent.id, 'Bank deposit']);

      // Update wallet (after Stripe confirmation in production)
      await client.query('INSERT INTO wallets (user_id, balance, currency_code) VALUES ($1, $2, $3) ON CONFLICT (user_id) DO UPDATE SET balance = wallets.balance + $2', [uid, amount, 'KES']);

      await client.query('COMMIT');
      logger.info(`Deposit initiated for user ${uid}: ${amount} KES`);
      res.status(200).json({ message: 'Deposit initiated', transaction: result.rows[0], client_secret: paymentIntent.client_secret });
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }
  } catch (error) {
    logger.error('Error processing deposit:', error);
    res.status(500).json({ error: 'Failed to process deposit' });
  }
});

// P2P transaction
app.post('/api/transactions/p2p', verifyToken, [
  check('receiver_phone').isMobilePhone('any'),
  check('amount').isFloat({ min: 0.01 }),
  check('pin').isLength({ min: 4, max: 4 }).isNumeric(),
], async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });

  const { receiver_phone, amount, pin } = req.body;
  const { uid } = req.user;

  try {
    // Verify PIN
    const user = await pool.query('SELECT pin_hash FROM users WHERE user_id = $1', [uid]);
    if (!user.rows[0]) return res.status(404).json({ error: 'User not found' });
    const pinMatch = await bcrypt.compare(pin, user.rows[0].pin_hash);
    if (!pinMatch) return res.status(401).json({ error: 'Invalid PIN' });

    // Find receiver
    const receiver = await pool.query('SELECT user_id FROM users WHERE phone_number = $1', [receiver_phone]);
    if (!receiver.rows[0]) return res.status(404).json({ error: 'Receiver not found' });

    // Check sender balance
    const senderWallet = await pool.query('SELECT balance FROM wallets WHERE user_id = $1', [uid]);
    if (!senderWallet.rows[0] || senderWallet.rows[0].balance < amount) {
      return res.status(400).json({ error: 'Insufficient balance' });
    }

    // Start transaction
    const client = await pool.connect();
    try {
      await client.query('BEGIN');

      // Record transaction
      const query = `
        INSERT INTO transactions (transaction_id, sender_id, receiver_id, amount, currency_code, transaction_type, status, description)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
        RETURNING *;
      `;
      const transactionId = uuidv4();
      const result = await client.query(query, [transactionId, uid, receiver.rows[0].user_id, amount, 'KES', 'P2P', 'COMPLETED', `P2P transfer to ${receiver_phone}`]);

      // Update wallets
      await client.query('UPDATE wallets SET balance = balance - $1 WHERE user_id = $2', [amount, uid]);
      await client.query('INSERT INTO wallets (user_id, balance, currency_code) VALUES ($1, $2, $3) ON CONFLICT (user_id) DO UPDATE SET balance = wallets.balance + $2', [receiver.rows[0].user_id, amount, 'KES']);

      await client.query('COMMIT');
      logger.info(`P2P transfer completed: ${amount} KES from ${uid} to ${receiver.rows[0].user_id}`);
      res.status(200).json({ message: 'P2P transfer completed', transaction: result.rows[0] });
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }
  } catch (error) {
    logger.error('Error processing P2P transfer:', error);
    res.status(500).json({ error: 'Failed to process P2P transfer' });
  }
});

// Merchant payment (e.g., public transport or daily transactions)
app.post('/api/transactions/payment', verifyToken, [
  check('merchant_id').isUUID(),
  check('amount').isFloat({ min: 0.01 }),
  check('pin').isLength({ min: 4, max: 4 }).isNumeric(),
], async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });

  const { merchant_id, amount, pin, description } = req.body;
  const { uid } = req.user;

  try {
    // Verify PIN
    const user = await pool.query('SELECT pin_hash FROM users WHERE user_id = $1', [uid]);
    if (!user.rows[0]) return res.status(404).json({ error: 'User not found' });
    const pinMatch = await bcrypt.compare(pin, user.rows[0].pin_hash);
    if (!pinMatch) return res.status(401).json({ error: 'Invalid PIN' });

    // Check sender balance
    const senderWallet = await pool.query('SELECT balance FROM wallets WHERE user_id = $1', [uid]);
    if (!senderWallet.rows[0] || senderWallet.rows[0].balance < amount) {
      return res.status(400).json({ error: 'Insufficient balance' });
    }

    // Start transaction
    const client = await pool.connect();
    try {
      await client.query('BEGIN');

      // Record transaction
      const query = `
        INSERT INTO transactions (transaction_id, sender_id, receiver_id, amount, currency_code, transaction_type, status, description)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
        RETURNING *;
      `;
      const transactionId = uuidv4();
      const result = await client.query(query, [transactionId, uid, merchant_id, amount, 'KES', 'PAYMENT', 'COMPLETED', description || 'Merchant payment']);

      // Update sender wallet
      await client.query('UPDATE wallets SET balance = balance - $1 WHERE user_id = $2', [amount, uid]);

      // Update merchant wallet (assuming merchant is a BAHM user)
      await client.query('INSERT INTO wallets (user_id, balance, currency_code) VALUES ($1, $2, $3) ON CONFLICT (user_id) DO UPDATE SET balance = wallets.balance + $2', [merchant_id, amount, 'KES']);

      await client.query('COMMIT');
      logger.info(`Payment completed: ${amount} KES from ${uid} to merchant ${merchant_id}`);
      res.status(200).json({ message: 'Payment completed', transaction: result.rows[0] });
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }
  } catch (error) {
    logger.error('Error processing payment:', error);
    res.status(500).json({ error: 'Failed to process payment' });
  }
});

// Wallet and transaction routes
const { mockWallets, mockTransactions } = require('./mock-data');

// GET wallet details by user ID
app.get('/api/wallet/:userId', verifyToken, async (req, res) => {
  const { userId } = req.params;

  try {
    // Ensure the user is authorized to access this wallet
    if (req.user.uid !== userId) {
      return res.status(403).json({ error: 'Unauthorized access to wallet' });
    }

    const result = await pool.query('SELECT * FROM wallets WHERE user_id = $1', [userId]);
    if (result.rows.length === 0) { 
        // Check if mock data exists
        const mockWallet = mockWallets[userId];
        if (mockWallet) {
            logger.info(`Returning mock wallet for user ${userId}`);
            return res.status(200).json(mockWallet);
        }
      return res.status(404).json({ error: 'Wallet not found' });
    }
    logger.info(`Wallet fetched for user ${userId}`);
    res.status(200).json(result.rows[0]);
  } catch (error) {
    logger.error(`Error fetching wallet for user ${userId}: ${error.message}`);
    res.status(500).json({ error: 'Failed to fetch wallet' });
  }
});

// GET transactions for a user (sent or received)
app.get('/api/transactions/:userId', verifyToken, async (req, res) => {
  const { userId } = req.params;
  const limit = parseInt(req.query.limit) || 5;

  try {
    // Ensure the user is authorized
    if (req.user.uid !== userId) {
      return res.status(403).json({ error: 'Unauthorized access to transactions' });
    }

    const result = await pool.query(
      'SELECT * FROM transactions WHERE sender_id = $1 OR receiver_id = $1 ORDER BY created_at DESC LIMIT $2',
      [userId, limit]
    );
    
    if (result.rows.length === 0) {
      // Return mock transactions for testing
      const userTransactions = mockTransactions.filter(
        t => t.sender_id === userId || t.receiver_id === userId
      ).slice(0, limit);
      
      if (userTransactions.length > 0) {
        logger.info(`Returning mock transactions for user ${userId}`);
        return res.status(200).json(userTransactions);
      }
    }
    
    logger.info(`Fetched ${result.rows.length} transactions for user ${userId}`);
    res.status(200).json(result.rows);
  } catch (error) {
    logger.error(`Error fetching transactions for user ${userId}: ${error.message}`);
    res.status(500).json({ error: 'Failed to fetch transactions' });
  }
});

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  logger.info(`Server running on port ${PORT}`);
});
