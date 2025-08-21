// src/models/transactionModel.js
const { Pool } = require('pg');

const pool = new Pool({
  user: 'your_user',
  host: 'localhost',
  database: 'bahm_db',
  password: 'your_password',
  port: 5432,
});

exports.createTransaction = async (senderId, recipientId, amount, type, authMethod) => {
  const result = await pool.query(
    'INSERT INTO transactions (sender_id, recipient_id, amount, type, auth_method, created_at) VALUES ($1, $2, $3, $4, $5, NOW()) RETURNING *',
    [senderId, recipientId, amount, type, authMethod]
  );
  return result.rows[0];
};