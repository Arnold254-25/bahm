// src/models/userModel.js
const admin = require('firebase-admin');

const db = admin.firestore();
const usersCollection = db.collection('users');

exports.getUser = async (userId) => {
  const userDoc = await usersCollection.doc(userId).get();
  return userDoc.exists ? userDoc.data() : null;
};

exports.updateBiometrics = async (userId, biometricsEnabled) => {
  await usersCollection.doc(userId).update({ biometricsEnabled });
};