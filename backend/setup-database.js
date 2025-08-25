const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

async function setupDatabase() {
  try {
    console.log('🚀 Setting up database...');
    
    // Create tables
    await pool.query(`
      CREATE TABLE IF NOT EXISTS wallets (
        id SERIAL PRIMARY KEY,
        user_id VARCHAR(255) UNIQUE NOT NULL,
        balance DECIMAL(15,2) DEFAULT 0.00,
        loyalty_points DECIMAL(15,2) DEFAULT 0.00,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    `);
    
    await pool.query(`
      CREATE TABLE IF NOT EXISTS transactions (
        id SERIAL PRIMARY KEY,
        sender_id VARCHAR(255) NOT NULL,
        receiver_id VARCHAR(255),
        amount DECIMAL(15,2) NOT NULL,
        type VARCHAR(50) NOT NULL,
        status VARCHAR(50) DEFAULT 'completed',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    `);
    
    // Insert sample data
    await pool.query(`
      INSERT INTO wallets (user_id, balance, loyalty_points) 
      VALUES 
      ('B1bfQrva3hf8L0Sj772exqScQ1J2', 1000.00, 50.00),
      ('test_user_1', 500.00, 25.00),
      ('test_user_2', 2000.00, 100.00)
      ON CONFLICT (user_id) DO NOTHING;
    `);
    
    await pool.query(`
      INSERT INTO transactions (sender_id, receiver_id, amount, type, status) 
      VALUES 
      ('B1bfQrva3hf8L0Sj772exqScQ1J2', 'test_user_1', 100.00, 'transfer', 'completed'),
      ('test_user_2', 'B1bfQrva3hf8L0Sj772exqScQ1J2', 50.00, 'transfer', 'completed'),
      ('B1bfQrva3hf8L0Sj772exqScQ1J2', 'test_user_2', 75.00, 'payment', 'completed'),
      ('test_user_1', 'B1bfQrva3hf8L0Sj772exqScQ1J2', 200.00, 'transfer', 'completed'),
      ('B1bfQrva3hf8L0Sj772exqScQ1J2', 'test_user_1', 25.00, 'payment', 'completed');
    `);
    
    // Create indexes
    await pool.query(`CREATE INDEX IF NOT EXISTS idx_wallets_user_id ON wallets(user_id);`);
    await pool.query(`CREATE INDEX IF NOT EXISTS idx_transactions_sender_id ON transactions(sender_id);`);
    await pool.query(`CREATE INDEX IF NOT EXISTS idx_transactions_receiver_id ON transactions(receiver_id);`);
    await pool.query(`CREATE INDEX IF NOT EXISTS idx_transactions_created_at ON transactions(created_at DESC);`);
    
    // Verify data
    const walletResult = await pool.query('SELECT * FROM wallets WHERE user_id = $1', ['B1bfQrva3hf8L0Sj772exqScQ1J2']);
    const transactionResult = await pool.query('SELECT * FROM transactions WHERE sender_id = $1 OR receiver_id = $1 ORDER BY created_at DESC LIMIT 5', ['B1bfQrva3hf8L0Sj772exqScQ1J2']);
    
    console.log('✅ Database setup complete!');
    console.log(`📊 Wallet found: ${walletResult.rows.length > 0 ? 'Yes' : 'No'}`);
    console.log(`📊 Transactions found: ${transactionResult.rows.length}`);
    
    if (walletResult.rows.length > 0) {
      console.log(`💰 Balance: KES ${walletResult.rows[0].balance}`);
    }
    
  } catch (error) {
    console.error('❌ Error setting up database:', error.message);
  } finally {
    await pool.end();
  }
}

setupDatabase();
