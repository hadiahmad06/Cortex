const dotenv = require('dotenv');
dotenv.config({ path: '.env.test' });

const request = require('supertest');
const app = require('../app.js'); // or wherever your Express app is exported

describe('POST /api/prompt', () => {
  it('should return a haiku for a given prompt', async () => {
    const res = await request(app)
      .post('/api/prompt')
      .send({
        apiKey: process.env.OPENROUTER_API_KEY,
        prompt: 'Write me a haiku about mortality.'
      });

    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('result');
    expect(typeof res.body.result).toBe('string');
    expect(res.body.result.length).toBeGreaterThan(0);
  });
});