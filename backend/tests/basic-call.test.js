const dotenv = require('dotenv');
dotenv.config({ path: '.env.test' });

const request = require('supertest');
const app = require('../app.js'); // or wherever your Express app is exported

describe('POST /api/prompt', () => {
  it('should debug the code for a given prompt', async () => {
    const res = await request(app)
      .post('/api/prompt')
      .send({
        apiKey: process.env.OPENROUTER_API_KEY,
        prompt: 'Debug this JS code: \n let x = 10;\n if (x < 5) {\n console.log("x is greater than 5");\n } else {\n console.log("x is not greater than 5");\n }'
      });

    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('result');
    expect(res.body).toHaveProperty('model');
    expect(typeof res.body.model).toBe('string');
    expect(res.body.model.length).toBeGreaterThan(0);
    expect(typeof res.body.result).toBe('string');
    expect(res.body.result.length).toBeGreaterThan(0);
  });

  // COMMENTED OUT TO REDUCE TOKEN USAGE
  
  // it('should use Claude model for very long prompts', async () => {
  //   const longPrompt = 'This is a long prompt. '.repeat(75); // ~1500 chars but meaningful text
  //   const res = await request(app)
  //     .post('/api/prompt')
  //     .send({
  //       apiKey: process.env.OPENROUTER_API_KEY,
  //       prompt: longPrompt
  //     });

  //   expect(res.statusCode).toBe(200);
  //   expect(res.body).toHaveProperty('model');
  //   expect(res.body.model).toBe('anthropic/claude-3-sonnet');
  // });

  it('should use Mistral model for summary prompts', async () => {
    const res = await request(app)
      .post('/api/prompt')
      .send({
        apiKey: process.env.OPENROUTER_API_KEY,
        prompt: 'Please summarize the following text.'
      });

    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('model');
    expect(res.body.model).toBe('mistralai/mistral-medium-3');
  });

  it('should fallback to GPT-3.5 for unknown prompt types', async () => {
    const res = await request(app)
      .post('/api/prompt')
      .send({
        apiKey: process.env.OPENROUTER_API_KEY,
        prompt: 'Tell me a joke.'
      });

    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('model');
    expect(res.body.model).toBe('openai/gpt-3.5-turbo');
  });

  it('should return 400 if prompt is missing', async () => {
    const res = await request(app)
      .post('/api/prompt')
      .send({
        apiKey: process.env.OPENROUTER_API_KEY
      });

    expect(res.statusCode).toBe(400);
    expect(res.body).toHaveProperty('error');
  });

  it('should return 400 if apiKey is missing', async () => {
    const res = await request(app)
      .post('/api/prompt')
      .send({
        prompt: 'Write me a haiku about Fairlife Chocolate Milk.'
      });

    expect(res.statusCode).toBe(400);
    expect(res.body).toHaveProperty('error');
  });
});