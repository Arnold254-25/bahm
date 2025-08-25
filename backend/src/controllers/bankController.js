const pool = require('../config/database');
const stripe = require('../config/stripe');
const logger = require('../config/logger');

const linkBankAccount = async (req, res) => {
  const { bank_name, account_number } = req.body;
  const { uid, email } = req.user;

  try {
    const customer = await stripe.customers.create({
      email,
      metadata: { firebase_uid: uid },
    });

    const setupIntent = await stripe.setupIntents.create({
      customer: customer.id,
      payment_method_types: ['card'], // Adjust for bank transfers
    });

    const encryptedAccountNumber = await pool.query(
      'SELECT pgp_sym_encrypt($1, $2) AS encrypted',
      [account_number, process.env.JWT_SECRET]
    );

    const query = `
      INSERT INTO bank_accounts (user_id, bank_name, account_number, stripe_customer_id, stripe_payment_method_id)
      VALUES ($1, $2, $3, $4, $5)
      RETURNING *;
    `;
    const result = await pool.query(query, [uid, bank_name, encryptedAccountNumber.rows[0].encrypted, customer.id, setupIntent.id]);
    logger.info(`Bank account linked for user ${uid}`);
    res.status(200).json({ message: 'Bank account linked', bank_account: result.rows[0], client_secret: setupIntent.client_secret });
  } catch (error) {
    logger.error('Error linking bank account:', error);
    res.status(500).json({ error: 'Failed to link bank account' });
  }
};

module.exports = { linkBankAccount };