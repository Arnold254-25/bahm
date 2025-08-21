const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const winston = require('winston');
require('dotenv').config();
const authRoutes = require('./routes/authRoutes');
const paymentRoutes = require('./routes/payment');
const bankRoutes = require('./routes/bank');

const app = express();

// Logger setup
const logger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  transports: [new winston.transports.File({ filename: 'combined.log' })],
});

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100,
}));

// Routes
app.use('/api', authRoutes);
app.use('/api', paymentRoutes);
app.use('/api', bankRoutes);

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  logger.info(`Server running on port ${PORT}`);
}); 