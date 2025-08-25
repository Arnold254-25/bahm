// Mock data for testing when database is not available
const mockWallets = {
  'B1bfQrva3hf8L0Sj772exqScQ1J2': {
    id: 1,
    user_id: 'B1bfQrva3hf8L0Sj772exqScQ1J2',
    balance: 1000.00,
    loyalty_points: 50.00,
    created_at: '2024-01-01T00:00:00Z',
    updated_at: '2024-01-01T00:00:00Z'
  },
  'test_user_1': {
    id: 2,
    user_id: 'test_user_1',
    balance: 500.00,
    loyalty_points: 25.00,
    created_at: '2024-01-01T00:00:00Z',
    updated_at: '2024-01-01T00:00:00Z'
  },
  'test_user_2': {
    id: 3,
    user_id: 'test_user_2',
    balance: 2000.00,
    loyalty_points: 100.00,
    created_at: '2024-01-01T00:00:00Z',
    updated_at: '2024-01-01T00:00:00Z'
  }
};

const mockTransactions = [
  {
    id: 1,
    sender_id: 'B1bfQrva3hf8L0Sj772exqScQ1J2',
    receiver_id: 'test_user_1',
    amount: 100.00,
    type: 'transfer',
    status: 'completed',
    created_at: '2024-01-01T10:00:00Z',
    updated_at: '2024-01-01T10:00:00Z'
  },
  {
    id: 2,
    sender_id: 'test_user_2',
    receiver_id: 'B1bfQrva3hf8L0Sj772exqScQ1J2',
    amount: 50.00,
    type: 'transfer',
    status: 'completed',
    created_at: '2024-01-01T11:00:00Z',
    updated_at: '2024-01-01T11:00:00Z'
  },
  {
    id: 3,
    sender_id: 'B1bfQrva3hf8L0Sj772exqScQ1J2',
    receiver_id: 'test_user_2',
    amount: 75.00,
    type: 'payment',
    status: 'completed',
    created_at: '2024-01-01T12:00:00Z',
    updated_at: '2024-01-01T12:00:00Z'
  },
  {
    id: 4,
    sender_id: 'test_user_1',
    receiver_id: 'B1bfQrva3hf8L0Sj772exqScQ1J2',
    amount: 200.00,
    type: 'transfer',
    status: 'completed',
    created_at: '2024-01-01T13:00:00Z',
    updated_at: '2024-01-01T13:00:00Z'
  },
  {
    id: 5,
    sender_id: 'B1bfQrva3hf8L0Sj772exqScQ1J2',
    receiver_id: 'test_user_1',
    amount: 25.00,
    type: 'payment',
    status: 'completed',
    created_at: '2024-01-01T14:00:00Z',
    updated_at: '2024-01-01T14:00:00Z'
  }
];

module.exports = {
  mockWallets,
  mockTransactions
};
