const bcrypt = require('bcrypt');
const pool = require('../config/database');
const logger = require('../config/logger');

const setPin = async (req, res) => {
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
};

module.exports = { setPin };