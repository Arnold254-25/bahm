const bcrypt = require('bcrypt');
const { v4: uuidv4 } = require('uuid');
const pool = require('../config/database');
const stripe = require('../config/stripe');
const logger = require('../config/logger');

const deposit = async (req, res) => {
  const { amount, bank_account_id, pin } = req.body;
  const { uid } = req.user;

  try {
    const user = await pool.query('SELECT pin_hash FROM users WHERE user_id = $1', [uid]);
    if (!user.rows[0]) return res.status(404).json({ error: 'User not found' });
    const pinMatch = await bcrypt.compare(pin, user.rows[0].pin_hash);
    if (!pinMatch) return res.status(401).json({ error: 'Invalid PIN' });

    const bankAccount = await pool.query('SELECT * FROM bank_accounts WHERE bank_account_id = $1 AND user_id = $2', [bank_account_id, uid]);
    if (!bankAccount.rows[0]) return res.status(404).json({ error: 'Bank account not found' });

    const paymentIntent = await stripe.paymentIntents.create({
      amount: Math.round(amount * 100),
      currency: 'kes',
      customer: bankAccount.rows[0].stripe_customer_id,
      payment_method: bankAccount.rows[0].stripe_payment_method_id,
      off_session: true,
      confirm: true,
    });

    const client = await pool.connect();
    try {
      await client.query('BEGIN');
      const query = `
        INSERT INTO transactions (transaction_id, sender_id, amount, currency_code, transaction_type, status, stripe_payment_intent_id, description)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
        RETURNING *;
      `;
      const transactionId = uuidv4();
      const result = await client.query(query, [transactionId, uid, amount, 'KES', 'BANK_DEPOSIT', 'PENDING', paymentIntent.id, 'Bank deposit']);
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
    logger.error(`Error processing deposit for user ${uid}: ${error.message}`);
    res.status(500).json({ error: 'Failed to process deposit' });
  }
};

const p2pTransfer = async (req, res) => {
  const { receiver_phone, amount, pin } = req.body;
  const { uid } = req.user;

  try {
    const user = await pool.query('SELECT pin_hash FROM users WHERE user_id = $1', [uid]);
    if (!user.rows[0]) return res.status(404).json({ error: 'User not found' });
    const pinMatch = await bcrypt.compare(pin, user.rows[0].pin_hash);
    if (!pinMatch) return res.status(401).json({ error: 'Invalid PIN' });

    const receiver = await pool.query('SELECT user_id FROM users WHERE phone_number = $1', [receiver_phone]);
    if (!receiver.rows[0]) return res.status(404).json({ error: 'Receiver not found' });

    const senderWallet = await pool.query('SELECT balance FROM wallets WHERE user_id = $1', [uid]);
    if (!senderWallet.rows[0] || senderWallet.rows[0].balance < amount) {
      return res.status(400).json({ error: 'Insufficient balance' });
    }

    const client = await pool.connect();
    try {
      await client.query('BEGIN');
      const query = `
        INSERT INTO transactions (transaction_id, sender_id, receiver_id, amount, currency_code, transaction_type, status, description)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
        RETURNING *;
      `;
      const transactionId = uuidv4();
      const result = await client.query(query, [transactionId, uid, receiver.rows[0].user_id, amount, 'KES', 'P2P', 'COMPLETED', `P2P transfer to ${receiver_phone}`]);
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
    logger.error(`Error processing P2P transfer for user ${uid}: ${error.message}`);
    res.status(500).json({ error: 'Failed to process P2P transfer' });
  }
};

const merchantPayment = async (req, res) => {
  const { merchant_id, amount, pin, description } = req.body;
  const { uid } = req.user;

  try {
    const user = await pool.query('SELECT pin_hash FROM users WHERE user_id = $1', [uid]);
    if (!user.rows[0]) return res.status(404).json({ error: 'User not found' });
    const pinMatch = await bcrypt.compare(pin, user.rows[0].pin_hash);
    if (!pinMatch) return res.status(401).json({ error: 'Invalid PIN' });

    const senderWallet = await pool.query('SELECT balance FROM wallets WHERE user_id = $1', [uid]);
    if (!senderWallet.rows[0] || senderWallet.rows[0].balance < amount) {
      return res.status(400).json({ error: 'Insufficient balance' });
    }

    const client = await pool.connect();
    try {
      await client.query('BEGIN');
      const query = `
        INSERT INTO transactions (transaction_id, sender_id, receiver_id, amount, currency_code, transaction_type, status, description)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
        RETURNING *;
      `;
      const transactionId = uuidv4();
      const result = await client.query(query, [transactionId, uid, merchant_id, amount, 'KES', 'PAYMENT', 'COMPLETED', description || 'Merchant payment']);
      await client.query('UPDATE wallets SET balance = balance - $1 WHERE user_id = $2', [amount, uid]);
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
    logger.error(`Error processing payment for user ${uid}: ${error.message}`);
    res.status(500).json({ error: 'Failed to process payment' });
  }
};

module.exports = { deposit, p2pTransfer, merchantPayment };