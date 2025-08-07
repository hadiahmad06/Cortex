const express = require("express");
const axios = require("axios");
const router = express.Router();

function chooseModel(prompt) {
  const lower = prompt.toLowerCase();
  const len = prompt.length;

  const scores = [
    {
      model: "openai/gpt-4",
      score: /code|bug|refactor|error/.test(lower) ? 2 : 0
    },
    {
      model: "anthropic/claude-3.7-sonnet",
      score: len > 1000 ? 1 : 0
    },
    {
      model: "mistralai/mistral-medium-3",
      score: /summary|summarize/.test(lower) ? 1 : 0
    },
    {
      model: "openai/gpt-3.5-turbo",
      score: 0.5 // default fallback
    }
  ];

  // Choose the model with the highest score
  scores.sort((a, b) => b.score - a.score);
  return scores[0].model;
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