const dotenv = require('dotenv');
dotenv.config({ path: '.env.test' });

const fs = require('fs');
const path = require('path');

const request = require('supertest');
const app = require('../app.js'); // or wherever your Express app is exported

function writeLog(testDescription, { statusCode, body }) {
  // Normalize the testDescription: lowercase, replace spaces with hyphens, remove all except lowercase letters, numbers, hyphens
  const normalized = testDescription
    .toLowerCase()
    .replace(/\s+/g, '-')
    .replace(/[^a-z0-9-]/g, '');
  const dir = path.join(__dirname, '../test-logs/api-prompt');
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
  const filePath = path.join(dir, `${normalized}.log`);
  const logContent = [
    `--- Test: ${testDescription} ---`,
    `Timestamp: ${new Date().toISOString()}`,
    '',
    `Status: ${statusCode}`,
    'Response Body:',
    JSON.stringify(body, null, 2),
    '',
    '-------------------------'
  ].join('\n');
  fs.writeFileSync(filePath, logContent);
}

describe.skip('POST /api/prompt', () => {
  // it('should return a result with requested and resolved models', async () => {
  //   const res = await request(app)
  //     .post('/api/prompt')
  //     .send({
  //       apiKey: process.env.OPENROUTER_API_KEY,
  //       prompt: 'I live in Minneapolis, MN. How far is it from Chicago, IL?'
  //     });

  //   writeLog('should return a result with requested and resolved models', {
  //     statusCode: res.statusCode,
  //     body: res.body
  //   });

    
  // });
});

describe.skip('POST /api/prompt', () => {
  it('should debug the code for a given prompt', async () => {
    const res = await request(app)
      .post('/api/prompt')
      .send({
        apiKey: process.env.OPENROUTER_API_KEY,
        prompt: 'Debug this JS code: \n let x = 10;\n if (x < 5) {\n console.log("x is greater than 5");\n } else {\n console.log("x is not greater than 5");\n }'
      });

    writeLog('should debug the code for a given prompt', {
      statusCode: res.statusCode,
      body: res.body
    });

    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('result');
    expect(res.body).toHaveProperty('requested_model');
    expect(res.body).toHaveProperty('resolved_model');
    expect(typeof res.body.requested_model).toBe('string');
    expect(typeof res.body.resolved_model).toBe('string');
    expect(res.body.requested_model.length).toBeGreaterThan(0);
    expect(res.body.resolved_model.length).toBeGreaterThan(0);
    expect(typeof res.body.result).toBe('string');
    expect(res.body.result.length).toBeGreaterThan(0);
    expect(res.body.requested_model).toBe('openai/gpt-4');
  });

  it.skip('should use Claude model for very long prompts', async () => {
    const longPrompt = 'This is a long prompt. '.repeat(75); // ~1500 chars but meaningful text
    const res = await request(app)
      .post('/api/prompt')
      .send({
        apiKey: process.env.OPENROUTER_API_KEY,
        prompt: longPrompt
      });

    writeLog('should use Claude model for very long prompts', {
      statusCode: res.statusCode,
      body: res.body
    });

    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('result');
    expect(res.body).toHaveProperty('requested_model');
    expect(res.body).toHaveProperty('resolved_model');
    expect(typeof res.body.requested_model).toBe('string');
    expect(typeof res.body.resolved_model).toBe('string');
    expect(res.body.requested_model.length).toBeGreaterThan(0);
    expect(res.body.resolved_model.length).toBeGreaterThan(0);
    expect(typeof res.body.result).toBe('string');
    expect(res.body.result.length).toBeGreaterThan(0);
    expect(res.body.requested_model).toBe('anthropic/claude-3.7-sonnet');
  });

  it('should use Mistral model for summary prompts', async () => {
    const res = await request(app)
      .post('/api/prompt')
      .send({
        apiKey: process.env.OPENROUTER_API_KEY,
        prompt: 'Please summarize the following text: My name is John Doe. I live in Minneapolis, MN. I am 30 years old. I have a dog named Rex. He is a golden retriever.'
      });

    writeLog('should use Mistral model for summary prompts', {
      statusCode: res.statusCode,
      body: res.body
    });

    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('result');
    expect(res.body).toHaveProperty('requested_model');
    expect(res.body).toHaveProperty('resolved_model');
    expect(typeof res.body.requested_model).toBe('string');
    expect(typeof res.body.resolved_model).toBe('string');
    expect(res.body.requested_model.length).toBeGreaterThan(0);
    expect(res.body.resolved_model.length).toBeGreaterThan(0);
    expect(typeof res.body.result).toBe('string');
    expect(res.body.result.length).toBeGreaterThan(0);
    expect(res.body.requested_model).toBe('mistralai/mistral-medium-3');
  });

  it('should fallback to OpenRouter auto for unknown prompt types', async () => {
    const res = await request(app)
      .post('/api/prompt')
      .send({
        apiKey: process.env.OPENROUTER_API_KEY,
        prompt: 'Tell me a joke.'
      });

    writeLog('should fallback to OpenRouter auto for unknown prompt types', {
      statusCode: res.statusCode,
      body: res.body
    });

    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('result');
    expect(res.body).toHaveProperty('requested_model');
    expect(res.body).toHaveProperty('resolved_model');
    expect(typeof res.body.requested_model).toBe('string');
    expect(typeof res.body.resolved_model).toBe('string');
    expect(res.body.requested_model.length).toBeGreaterThan(0);
    expect(res.body.resolved_model.length).toBeGreaterThan(0);
    expect(typeof res.body.result).toBe('string');
    expect(res.body.result.length).toBeGreaterThan(0);
    expect(res.body.requested_model).toBe('openrouter/auto');
  });

  it('should return 400 if prompt is missing', async () => {
    const res = await request(app)
      .post('/api/prompt')
      .send({
        apiKey: process.env.OPENROUTER_API_KEY
      });

    writeLog('should return 400 if prompt is missing', {
      statusCode: res.statusCode,
      body: res.body
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

    writeLog('should return 400 if apiKey is missing', {
      statusCode: res.statusCode,
      body: res.body
    });

    expect(res.statusCode).toBe(400);
    expect(res.body).toHaveProperty('error');
  });
});