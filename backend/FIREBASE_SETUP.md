# Firebase Setup Guide for BAHM Backend

## Current Status ✅
The backend is now running successfully in **development mode** with mock Firebase authentication.

## To Enable Full Firebase Features:

### 1. Get Firebase Service Account
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Go to Project Settings → Service Accounts
4. Click "Generate new private key"
5. Download the JSON file

### 2. Update Firebase Service Account
Replace the contents of `backend/firebase-service-account.json` with your actual service account JSON.

### 3. Verify Configuration
The service account JSON should contain:
```json
{
  "type": "service_account",
  "project_id": "your-actual-project-id",
  "private_key_id": "your-actual-private-key-id",
  "private_key": "-----BEGIN PRIVATE KEY-----\nYOUR_ACTUAL_PRIVATE_KEY\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-xxxxx@your-project-id.iam.gserviceaccount.com",
  "client_id": "your-actual-client-id",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-xxxxx%40your-project-id.iam.gserviceaccount.com"
}
```

### 4. Environment Variables
Update `backend/.env` with your actual values:
```
DATABASE_URL=postgresql://username:password@localhost:5432/bahm_db
STRIPE_SECRET_KEY=sk_test_your_actual_stripe_key
JWT_SECRET=your_actual_jwt_secret
```

## Development Mode Features
- ✅ Mock Firebase authentication (accepts any token)
- ✅ Development user ID: `dev-user-id`
- ✅ Development email: `dev@example.com`
- ✅ All API endpoints functional

## Production Setup
When you're ready for production:
1. Replace the mock service account with real credentials
2. Update environment variables
3. Set up a real PostgreSQL database
4. Configure proper Stripe keys

## Testing the Backend
The backend should now be accessible at:
- **Local**: http://localhost:3000
- **API Base**: http://localhost:3000/api

Test endpoints:
- POST /api/users/set-pin
- POST /api/bank-accounts
- POST /api/transactions/deposit
- POST /api/transactions/p2p
- POST /api/transactions/payment
