# BAHM App API Setup Guide

## 🚨 Problem Solved: ERR_NAME_NOT_RESOLVED

The error `net::ERR_NAME_NOT_RESOLVED` was caused by placeholder URLs (`http://your-api-url`) that don't exist. This has been fixed by creating a centralized configuration system.

## ✅ Changes Made

1. **Created centralized configuration** in `lib/config/app_config.dart`
2. **Updated all API endpoints** to use the new configuration
3. **Replaced placeholder URLs** with configurable base URLs

## 🛠️ Setup Instructions

### 1. Start Your Backend Server
```bash
cd backend
npm install  # if not already done
npm start
```

Your backend should now be running on `http://localhost:3000`

### 2. Configure Flutter App

#### For Android Emulator:
Update `lib/config/app_config.dart`:
```dart
static const String baseUrl = 'http://10.0.2.2:3000/api';
```

#### For iOS Simulator:
Update `lib/config/app_config.dart`:
```dart
static const String baseUrl = 'http://localhost:3000/api';
```

#### For Physical Device:
1. Find your machine's IP address (run `ipconfig` on Windows or `ifconfig` on Mac/Linux)
2. Update `lib/config/app_config.dart`:
```dart
static const String baseUrl = 'http://YOUR_IP_ADDRESS:3000/api';
```

### 3. Network Configuration

#### Android (Physical Device)
Add to `android/app/src/main/AndroidManifest.xml` inside `<application>` tag:
```xml
android:usesCleartextTraffic="true"
```

#### iOS (Simulator/Device)
Add to `ios/Runner/Info.plist`:
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

### 4. Environment Variables (Optional)
You can also use environment variables:
```bash
flutter run --dart-define=API_BASE_URL=http://localhost:3000/api
```

## 🔍 Testing Your Setup

1. **Test Backend**: Visit `http://localhost:3000/api` in your browser
2. **Test Flutter App**: Run the app and check if API calls succeed
3. **Check Network**: Ensure your device/emulator can reach your development machine

## 📋 Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| `Connection refused` | Backend server not running or wrong port |
| `Network security error` | Add network security config (Android) |
| `iOS transport security` | Update Info.plist for HTTP |
| `Physical device can't connect` | Use machine's IP address, check firewall |

## 🎯 Next Steps

1. Start your backend server
2. Update the base URL in `lib/config/app_config.dart`
3. Run your Flutter app
4. Test the wallet and transaction endpoints
