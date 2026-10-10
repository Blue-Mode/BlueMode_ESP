import express from "express";
import OpenAI from "openai";

const app = express();

app.use(express.json({ limit: "32kb" }));

const PORT = process.env.PORT || 3000;
const API_KEY = process.env.OPENAI_API_KEY;

if (!API_KEY) {
    console.error("ERROR: OPENAI_API_KEY is missing!");
    process.exit(1);
}

const openai = new OpenAI({
    apiKey: API_KEY
});

// Homepage
app.get("/", (req, res) => {
    res.send("Blue Mode AI backend is running!");
});

// Health check
app.get("/health", (req, res) => {
    res.json({ ok: true });
});

// AI chat
app.post("/chat", async (req, res) => {
    try {
        const message = req.body?.message;

        if (typeof message !== "string" || !message.trim()) {
            return res.status(400).json({
                error: "Please provide a message."
            });
        }

        const response = await openai.responses.create({
            model: process.env.OPENAI_MODEL || "gpt-4.1-mini",
            instructions:
                "You are Blue Mode AI, a helpful AI assistant specializing in explaining and writing Lua code.",
            input: message.trim(),
            max_output_tokens: 1800
        });

        return res.json({
            reply: response.output_text || "No response received."
        });

    } catch (error) {
        console.error("Blue Mode AI error:", error);

        return res.status(error.status === 429 ? 429 : 500).json({
            error: "AI request failed",
            details: error.message || "Unknown server error"
        });
    }
});

// Handle unknown routes
app.use((req, res) => {
    res.status(404).json({
        error: "Route not found"
    });
});

app.listen(PORT, "0.0.0.0", () => {
    console.log(`Blue Mode AI listening on port ${PORT}`);
});
