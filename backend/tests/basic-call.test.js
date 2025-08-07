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

    console.log('RESPONSE:', res.body);

    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('result');
    expect(res.body).toHaveProperty('model');
    expect(typeof res.body.model).toBe('string');
    expect(res.body.model.length).toBeGreaterThan(0);
    expect(typeof res.body.result).toBe('string');
    expect(res.body.result.length).toBeGreaterThan(0);
  });
});

describe('POST /api/prompt', () => {
  it('should debug the code for a given prompt', async () => {
    const res = await request(app)
      .post('/api/prompt')
      .send({
        apiKey: process.env.OPENROUTER_API_KEY,
        prompt: 'Debug this JS code: \n let x = 10;\n if (x < 5) {\n console.log("x is greater than 5");\n } else {\n console.log("x is not greater than 5");\n }'
      });

    console.log('RESPONSE:', res.body);

    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('result');
    expect(res.body).toHaveProperty('model');
    expect(typeof res.body.model).toBe('string');
    expect(res.body.model.length).toBeGreaterThan(0);
    expect(typeof res.body.result).toBe('string');
    expect(res.body.result.length).toBeGreaterThan(0);
  });
});