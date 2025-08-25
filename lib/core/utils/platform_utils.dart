import 'package:flutter/foundation.dart';

class PlatformUtils {
  static bool get isWeb => kIsWeb;
  static bool get isMobile => !kIsWeb;
  
  static String getBackendUrl() {
    if (kIsWeb) {
      return 'http://localhost:3000/api';
    } else {
      // For mobile devices, use your machine's IP address
      // This should be updated to your actual backend URL in production
      return 'http://10.0.2.2:3000/api'; // Android emulator
      // For physical device testing, use your machine's IP:
      // return 'http://192.168.1.100:3000/api';
    }
  }
}
