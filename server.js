app.post("/chat", async (req, res) => {
    try {
        const message = req.body?.message;

        if (!message || typeof message !== "string") {
            return res.status(400).json({
                error: "Please provide a message."
            });
        }

        const response = await openai.responses.create({
            model: process.env.OPENAI_MODEL || "gpt-4.1-mini",
            instructions: "You are Blue Mode AI, a helpful coding assistant.",
            input: message,
            max_output_tokens: 1800
        });

        res.json({
            reply: response.output_text || "No response received."
        });

    } catch (error) {
        console.error("Blue Mode AI error:", error.status, error.message);

        res.status(500).json({
            error: "AI request failed",
            details: error.message
        });
    }
});
