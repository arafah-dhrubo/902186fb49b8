const rateLimit = require('express-rate-limit');

// Request Logging Middleware
const requestLogger = (req, res, next) => {
    const timestamp = new Date().toISOString();
    console.log(`[${timestamp}] ${req.method} ${req.url}`);
    if (req.method === 'POST') {
        console.log('  Body:', JSON.stringify(req.body));
    }
    next();
};

// Rate Limiting Middleware (30 requests per minute per IP)
const apiLimiter = rateLimit({
    windowMs: 60 * 1000, // 1 minute
    max: 30,
    message: { error: 'Too many requests, please try again later.' },
    standardHeaders: true,
    legacyHeaders: false,
});

module.exports = { requestLogger, apiLimiter };
