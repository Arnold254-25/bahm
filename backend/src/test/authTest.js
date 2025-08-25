const request = require('supertest');
const app = require('../app');

describe('POST /api/set-pin', () => {
  it('should set PIN successfully', async () => {
    const res = await request(app)
      .post('/api/set-pin')
      .set('Authorization', 'Bearer valid_token')
      .send({ pin: '1234', phone_number: '+254123456789' });
    expect(res.status).toBe(200);
    expect(res.body.message).toBe('PIN set successfully');
  });
});