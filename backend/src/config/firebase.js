const admin = require('firebase-admin');
const path = require('path');
const fs = require('fs');
require('dotenv').config();

let adminApp;

try {
  console.log('🔍 Checking Firebase service account configuration...');
  
  // Get the correct path to the service account file (one level up from src)
  const serviceAccountPath = path.resolve(__dirname, '../../firebase-service-account.json');
  console.log(`📁 Service account path: ${serviceAccountPath}`);
  
  // Check if the file exists
  if (!fs.existsSync(serviceAccountPath)) {
    throw new Error(`Service account file not found at: ${serviceAccountPath}`);
  }
  
  // Read and validate the service account
  const serviceAccount = require(serviceAccountPath);
  console.log('📋 Service account file loaded successfully');
  
  // Validate required fields
  const requiredFields = ['project_id', 'private_key', 'client_email'];
  const missingFields = requiredFields.filter(field => !serviceAccount[field]);
  
  if (missingFields.length > 0) {
    throw new Error(`Missing required fields in service account: ${missingFields.join(', ')}`);
  }
  
  // Validate private key format
  if (!serviceAccount.private_key.includes('-----BEGIN PRIVATE KEY-----')) {
    throw new Error('Invalid private key format in service account');
  }
  
  // Initialize Firebase Admin
  adminApp = admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  });
  
  console.log('✅ Firebase Admin initialized successfully');
  console.log(`🎯 Project ID: ${serviceAccount.project_id}`);
  console.log(`👤 Client Email: ${serviceAccount.client_email}`);
  
} catch (error) {
  console.error('❌ Firebase initialization error:', error.message);
  console.warn('⚠️  Warning: Firebase service account not configured properly');
  console.warn('   Using development mode - Firebase features will be limited');
  
  // Create a mock admin for development
  adminApp = {
    auth: () => ({
      verifyIdToken: async (token) => {
        console.log('🔧 Development mode: Accepting mock token');
        return {
          uid: 'dev-user-id',
          email: 'dev@example.com',
          name: 'Development User'
        };
      }
    }),
    firestore: () => ({
      collection: () => ({
        doc: () => ({
          get: async () => ({ exists: false }),
          set: async () => console.log('🔧 Development mode: Mock Firestore set'),
          update: async () => console.log('🔧 Development mode: Mock Firestore update')
        })
      })
    })
  };
}

module.exports = adminApp || admin;
