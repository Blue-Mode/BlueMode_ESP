// ==============================================
// 🔵 BLUE MODE — SIMPLE CHAT SERVER
// ==============================================

const express = require('express');
const cors = require('cors');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Store messages in memory
let messages = [];

// ✅ GET all messages
app.get('/messages', (req, res) => {
    res.json({ messages: messages.slice(-50) }); // Keep last 50 only
});

// ✅ POST new message
app.post('/send', (req, res) => {
    const { username, server, message, isBroadcast, timestamp } = req.body;
    
    if (!username || !message) {
        return res.status(400).json({ error: 'Missing fields' });
    }
    
    messages.push({
        username: username || 'Anonymous',
        server: server || 'Unknown',
        message: message,
        isBroadcast: isBroadcast || false,
        timestamp: timestamp || new Date().toLocaleTimeString()
    });
    
    res.json({ success: true });
});

// ✅ Root test
app.get('/', (req, res) => {
    res.send('🔵 Blue Mode Chat Server Online! ✅');
});

// ✅ Start server
app.listen(PORT, () => {
    console.log(`🔵 Blue Mode Chat running on port ${PORT}`);
});
