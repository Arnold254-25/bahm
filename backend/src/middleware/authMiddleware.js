const admin = require('../config/firebase');
const logger = require('../config/logger');

const verifyToken = async (req, res, next) => {
  const token = req.headers.authorization?.split('Bearer ')[1];
  if (!token) return res.status(401).json({ error: 'No token provided' });
  try {
    const decoded = await admin.auth().verifyIdToken(token);
    req.user = decoded;
    next();
  } catch (error) {
    logger.error('Token verification failed:', error);
    res.status(401).json({ error: 'Invalid token' });
  }
};

module.exports = verifyToken;