const express = require('express');
const router = express.Router();
const pool = require('../config/database');
const logger = require('../config/logger');
const verifyToken = require('../middleware/authMiddleware');
const { validateDeposit, validateP2P, validatePayment, validate } = require('../middleware/validator');
const { deposit, p2pTransfer, merchantPayment } = require('../controllers/transactionController');
const { mockWallets, mockTransactions } = require('../mock-data');

// GET wallet details by user ID
router.get('/wallet/:userId', verifyToken, async (req, res) => {
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
router.get('/transactions/:userId', verifyToken, async (req, res) => {
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
    logger.info(`Fetched ${result.rows.length} transactions for user ${userId}`);
    res.status(200).json(result.rows);
  } catch (error) {
    logger.error(`Error fetching transactions for user ${userId}: ${error.message}`);
    res.status(500).json({ error: 'Failed to fetch transactions' });
  }
});

// POST deposit (bank-to-wallet)
router.post('/deposit', verifyToken, validateDeposit, validate, deposit);

// POST P2P transfer
router.post('/p2p', verifyToken, validateP2P, validate, p2pTransfer);

// POST merchant payment
router.post('/payment', verifyToken, validatePayment, validate, merchantPayment);

module.exports = router;