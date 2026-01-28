require('dotenv').config();
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');

const { closeDatabase } = require('./src/database');
const { requestLogger, apiLimiter } = require('./src/middleware');
const vitalsRoutes = require('./src/routes');

const app = express();
const PORT = process.env.PORT || 8000;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(requestLogger);

// Routes (with rate limiting)
app.use('/api/vitals', apiLimiter, vitalsRoutes);

// Health Check Endpoint
app.get('/health', (req, res) => {
    res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Start Server
const server = app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});

// Graceful Shutdown
const gracefulShutdown = async () => {
    console.log('\nShutting down gracefully...');
    server.close(async () => {
        await closeDatabase();
        console.log('Server closed.');
        process.exit(0);
    });
};

process.on('SIGINT', gracefulShutdown);
process.on('SIGTERM', gracefulShutdown);
