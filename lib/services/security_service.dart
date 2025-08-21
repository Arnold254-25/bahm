import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:bahm/core/utils/platform_utils.dart';

// Enum for biometric status
enum BiometricStatus {
  available,
  notSupported,
  notAvailable,
  notEnrolled,
  error,
}

class SecurityService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  static const String _pinKey = 'user_pin';
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _securitySetupCompletedKey = 'security_setup_completed';

  final LocalAuthentication _localAuth = LocalAuthentication();

  // PIN Management
  Future<void> storePin(String pin) async {
    await _storage.write(key: _pinKey, value: pin);
  }

  Future<String?> getPin() async {
    return await _storage.read(key: _pinKey);
  }

  Future<bool> validatePin(String pin) async {
    final storedPin = await getPin();
    return storedPin == pin;
  }

  Future<void> clearPin() async {
    await _storage.delete(key: _pinKey);
  }

  // Biometric Management
  Future<void> setBiometricEnabled(bool enabled) async {
    await _storage.write(key: _biometricEnabledKey, value: enabled.toString());
  }

  Future<bool> isBiometricEnabled() async {
    final value = await _storage.read(key: _biometricEnabledKey);
    return value == 'true';
  }

  // Security Setup Status
  Future<void> setSecuritySetupCompleted(bool completed) async {
    await _storage.write(key: _securitySetupCompletedKey, value: completed.toString());
  }

  Future<bool> isSecuritySetupCompleted() async {
    final value = await _storage.read(key: _securitySetupCompletedKey);
    return value == 'true';
  }

  // Platform-specific implementation
  Future<bool> isDeviceSupported() async {
    if (kIsWeb) {
      return false;
    }
    try {
      return await _localAuth.isDeviceSupported();
    } catch (e) {
      print('Error checking device support: $e');
      return false;
    }
  }

  Future<bool> canCheckBiometrics() async {
    if (kIsWeb) {
      return false;
    }
    try {
      final bool canCheck = await _localAuth.canCheckBiometrics;
      final bool isDeviceSupp = await _localAuth.isDeviceSupported();
      return canCheck && isDeviceSupp;
    } catch (e) {
      print('Error checking biometrics: $e');
      return false;
    }
  }

  Future<bool> authenticateWithBiometrics(String reason) async {
    if (kIsWeb) {
      return false;
    }
    try {
      final bool isAvailable = await canCheckBiometrics();
      
      if (!isAvailable) {
        return false;
      }

      return await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: false, // Allow fallback to device credentials
          stickyAuth: true,
          sensitiveTransaction: true,
        ),
      );
    } catch (e) {
      print('Error during biometric authentication: $e');
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    if (kIsWeb) {
      return [];
    }
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      print('Error getting available biometrics: $e');
      return [];
    }
  }

  // Comprehensive biometric check
  Future<BiometricStatus> checkBiometricStatus() async {
    if (kIsWeb) {
      return BiometricStatus.notSupported;
    }
    
    try {
      final bool isSupported = await _localAuth.isDeviceSupported();
      final bool canCheck = await _localAuth.canCheckBiometrics;
      
      debugPrint('Device supported: $isSupported');
      debugPrint('Can check biometrics: $canCheck');
      
      if (!isSupported) {
        return BiometricStatus.notSupported;
      }
      
      if (!canCheck) {
        return BiometricStatus.notAvailable;
      }
      
      final List<BiometricType> available = await _localAuth.getAvailableBiometrics();
      debugPrint('Available biometrics: $available');
      
      if (available.isEmpty) {
        return BiometricStatus.notEnrolled;
      }
      
      return BiometricStatus.available;
    } catch (e) {
      debugPrint('Error checking biometric status: $e');
      return BiometricStatus.error;
    }
  }

  // Clear all security data (for logout)
  Future<void> clearAllSecurityData() async {
    await _storage.deleteAll();
  }
}
