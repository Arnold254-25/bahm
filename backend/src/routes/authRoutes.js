const express = require('express');
const router = express.Router();
const { setPin } = require('../controllers/authController');
const verifyToken = require('../middleware/authMiddleware');
const { validateSetPin, validate } = require('../middleware/validator');

// Existing auth routes (if any)
router.post('/set-pin', verifyToken, validateSetPin, validate, setPin);

module.exports = router;