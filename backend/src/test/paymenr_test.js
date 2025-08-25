const request = require('supertest');
const app = require('../app');

describe('GET /api/wallet/:userId', () => {
  it('should fetch wallet details', async () => {
    const userId = '123e4567-e89b-12d3-a456-426614174000';
    const res = await request(app)
      .get(`/api/wallet/${userId}`)
      .set('Authorization', 'Bearer valid_token');
    expect(res.status).toBe(200);
    expect(res.body).toHaveProperty('balance');
  });
});