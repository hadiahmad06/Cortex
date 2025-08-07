const express = require("express");
const axios = require("axios");
const router = express.Router();

function chooseModel(prompt) {
  const len = prompt.length;
  if (/code|bug|refactor|error/i.test(prompt)) return "openai/gpt-4";
  if (len > 1000) return "anthropic/claude-3-sonnet";
  if (/summary|summarize/i.test(prompt)) return "mistralai/mixtral-8x7b";
  return "openai/gpt-3.5-turbo";
}

router.post("/", async (req, res) => {
  const { prompt, apiKey, model } = req.body;

  if (!prompt || !apiKey) {
    return res.status(400).json({ error: "Missing prompt or API key" });
  }

  const chosenModel = model || chooseModel(prompt);

  try {
    const response = await axios.post(
      "https://openrouter.ai/api/v1/chat/completions",
      {
        model: chosenModel,
        messages: [{ role: "user", content: prompt }],
      },
      {
        headers: {
          Authorization: `Bearer ${apiKey}`,
          "HTTP-Referer": "https://yourapp.com",
          "Content-Type": "application/json",
        },
      }
    );

    res.json({ 
      result: response.data.choices[0].message.content,
      model: chosenModel
    });
  } catch (err) {
    console.error(err?.response?.data || err.message);
    res.status(err?.response?.status || 500).json({
      error: "LLM error",
      details: err?.response?.data || err.message,
    });
  }
});

module.exports = router;