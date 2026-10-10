import express from "express";
import OpenAI from "openai";

const app = express();
app.use(express.json({ limit: "32kb" }));

const apiKey = process.env.OPENAI_API_KEY;

if (!apiKey) {
  console.error("Missing OPENAI_API_KEY environment variable");
  process.exit(1);
}

const openai = new OpenAI({ apiKey });

app.get("/", (req, res) => {
  res.send("Blue Mode AI Backend is running!");
});

app.get("/health", (req, res) => {
  res.json({ ok: true });
});

app.post("/chat", async (req, res) => {
  try {
    const message = req.body?.message;

    if (typeof message !== "string" || !message.trim()) {
      return res.status(400).json({
        error: "Please provide a message."
      });
    }

    if (message.length > 8000) {
      return res.status(413).json({
        error: "Message is too long."
      });
    }

    const response = await openai.responses.create({
      model: process.env.OPENAI_MODEL || "gpt-4.1-mini",
      instructions:
        "You are Blue Mode AI, a helpful coding assistant. " +
        "You can explain and generate Lua code. " +
        "Generated code must be reviewed before use.",
      input: message,
      max_output_tokens: 1800
    });

    res.json({
      reply: response.output_text || "No response received."
    });
  } catch (error) {
    console.error("AI error:", error.message);

    res.status(500).json({
      error: "AI request failed. Check your API setup."
    });
  }
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Blue Mode AI listening on port ${PORT}`);
});
