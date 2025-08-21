-- Database Setup Script for BAHM Backend
-- This script creates the required tables for wallet and transactions

-- Create wallets table
CREATE TABLE IF NOT EXISTS wallets (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255) UNIQUE NOT NULL,
    balance DECIMAL(15,2) DEFAULT 0.00,
    loyalty_points DECIMAL(15,2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create transactions table
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

-- Insert sample data for testing
-- Replace 'B1bfQrva3hf8L0Sj772exqScQ1J2' with your actual user ID
INSERT INTO wallets (user_id, balance, loyalty_points) 
VALUES 
('B1bfQrva3hf8L0Sj772exqScQ1J2', 1000.00, 50.00),
('test_user_1', 500.00, 25.00),
('test_user_2', 2000.00, 100.00)
ON CONFLICT (user_id) DO NOTHING;

-- Insert sample transactions
INSERT INTO transactions (sender_id, receiver_id, amount, type, status) 
VALUES 
('B1bfQrva3hf8L0Sj772exqScQ1J2', 'test_user_1', 100.00, 'transfer', 'completed'),
('test_user_2', 'B1bfQrva3hf8L0Sj772exqScQ1J2', 50.00, 'transfer', 'completed'),
('B1bfQrva3hf8L0Sj772exqScQ1J2', 'test_user_2', 75.00, 'payment', 'completed'),
('test_user_1', 'B1bfQrva3hf8L0Sj772exqScQ1J2', 200.00, 'transfer', 'completed'),
('B1bfQrva3hf8L0Sj772exqScQ1J2', 'test_user_1', 25.00, 'payment', 'completed');

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_wallets_user_id ON wallets(user_id);
CREATE INDEX IF NOT EXISTS idx_transactions_sender_id ON transactions(sender_id);
CREATE INDEX IF NOT EXISTS idx_transactions_receiver_id ON transactions(receiver_id);
CREATE INDEX IF NOT EXISTS idx_transactions_created_at ON transactions(created_at DESC);

-- Verify data insertion
SELECT 'Wallets count: ' || COUNT(*) FROM wallets;
SELECT 'Transactions count: ' || COUNT(*) FROM transactions;
SELECT * FROM wallets WHERE user_id = 'B1bfQrva3hf8L0Sj772exqScQ1J2';
SELECT * FROM transactions WHERE sender_id = 'B1bfQrva3hf8L0Sj772exqScQ1J2' OR receiver_id = 'B1bfQrva3hf8L0Sj772exqScQ1J2' ORDER BY created_at DESC LIMIT 5;
