const { check, validationResult } = require('express-validator');

const validateSetPin = [
  check('pin').isLength({ min: 4, max: 4 }).isNumeric(),
  check('phone_number').isMobilePhone('any'),
];

const validateBankAccount = [
  check('bank_name').notEmpty(),
  check('account_number').notEmpty(),
];

const validateDeposit = [
  check('amount').isFloat({ min: 0.01 }),
  check('bank_account_id').isUUID(),
  check('pin').isLength({ min: 4, max: 4 }).isNumeric(),
];

const validateP2P = [
  check('receiver_phone').isMobilePhone('any'),
  check('amount').isFloat({ min: 0.01 }),
  check('pin').isLength({ min: 4, max: 4 }).isNumeric(),
];

const validatePayment = [
  check('merchant_id').isUUID(),
  check('amount').isFloat({ min: 0.01 }),
  check('pin').isLength({ min: 4, max: 4 }).isNumeric(),
];

const validate = (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  next();
};

module.exports = {
  validateSetPin,
  validateBankAccount,
  validateDeposit,
  validateP2P,
  validatePayment,
  validate,
};