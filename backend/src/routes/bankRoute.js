const express = require('express');
const router = express.Router();
const { linkBankAccount } = require('../controllers/bankController');
const verifyToken = require('../middleware/authMiddleware');
const { validateBankAccount, validate } = require('../middleware/validator');

router.post('/', verifyToken, validateBankAccount, validate, linkBankAccount);

module.exports = router;