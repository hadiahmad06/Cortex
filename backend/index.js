const express = require("express");
const axios = require("axios");
const cors = require("cors");

const app = express();
app.use(cors());
app.use(express.json());

function chooseModel(prompt) {
  const len = prompt.length;
  if (/code|bug|refactor|error/i.test(prompt)) return "openai/gpt-4";
  if (len > 1000) return "anthropic/claude-3-sonnet";
  if (/summary|summarize/i.test(prompt)) return "mistralai/mixtral-8x7b";
  return "openai/gpt-3.5-turbo";
}

app.post("/api/prompt", async (req, res) => {
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
          "HTTP-Referer": "https://yourapp.com", // optional but recommended
          "Content-Type": "application/json",
        },
      }
    );

    res.json({ result: response.data.choices[0].message.content });
  } catch (err) {
    console.error(err?.response?.data || err.message);
    res.status(err?.response?.status || 500).json({
      error: "LLM error",
      details: err?.response?.data || err.message,
    });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Backend running on http://localhost:${PORT}`);
});