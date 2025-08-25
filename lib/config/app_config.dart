import 'package:bahm/core/utils/platform_utils.dart';

class AppConfig {
  // Base API URL - uses platform-aware URL
  static String get baseUrl {
    return PlatformUtils.getBackendUrl();
  }

  // Backend Base URL
  static String get backendBaseUrl {
    return PlatformUtils.getBackendUrl(); // Adjust this as needed
  }

  // For production, set this environment variable
  // flutter run --dart-define=API_BASE_URL=https://your-api.com/api

  // Analytics endpoint
  static String get analyticsUrl => '$baseUrl/analytics';

  // Payment endpoints
  static String get walletUrl => '$baseUrl/wallet';
  static String get transactionsUrl => '$baseUrl/transactions';
  static String get paymentUrl => '$baseUrl/payment';

  // Auth endpoints
  static String get authUrl => baseUrl;
}
