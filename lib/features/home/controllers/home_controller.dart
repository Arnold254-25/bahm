import 'package:bahm/models/transactionModel.dart';
import 'package:bahm/models/walletModel.dart';
import 'package:local_auth/local_auth.dart';
import '../../payments/domain/payment_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../../core/services/cache_service_new.dart';

class HomeController extends ChangeNotifier {
  final PaymentService paymentService;
  final LocalAuthentication localAuth = LocalAuthentication();
  Wallet? wallet;
  List<Transaction> transactions = [];
  String? errorMessage;
  bool isLoading = false;
  bool isRefreshing = false;
  bool canUseBiometrics = false;

  HomeController(this.paymentService) {
    _initialize();
  }

  Future<void> _initialize() async {
    await checkBiometricSupport();
    await loadCachedData();
  }

  Future<void> checkBiometricSupport() async {
    if (kIsWeb) {
      canUseBiometrics = false;
      return;
    }
    try {
      final bool canCheck = await localAuth.canCheckBiometrics;
      final bool isSupported = await localAuth.isDeviceSupported();
      canUseBiometrics = canCheck && isSupported;
    } catch (e) {
      canUseBiometrics = false;
      debugPrint('Error checking biometric support: $e');
    }
  }

  Future<bool> authenticateWithBiometrics() async {
    if (kIsWeb) {
      return false;
    }
    try {
      final bool isAvailable = await localAuth.canCheckBiometrics && await localAuth.isDeviceSupported();
      if (!isAvailable) {
        return false;
      }
      
      return await localAuth.authenticate(
        localizedReason: 'Authenticate to perform action',
        options: const AuthenticationOptions(
          biometricOnly: false, // Allow fallback to device credentials
          stickyAuth: true,
        ),
      );
    } catch (e) {
      debugPrint('Biometric authentication error: $e');
      return false;
    }
  }

  Future<void> loadCachedData() async {
    final cachedWallet = await CacheService.getCachedWallet();
    final cachedTransactions = await CacheService.getCachedTransactions();
    
    if (cachedWallet != null) {
      wallet = cachedWallet;
    }
    
    if (cachedTransactions.isNotEmpty) {
      transactions = cachedTransactions;
    }
    
    notifyListeners();
  }

  Future<void> fetchAllData(String userId, String token) async {
    if (isLoading || isRefreshing) return;
    
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Check if we should use cached data
      final shouldRefresh = await CacheService.shouldRefreshData();
      
      if (!shouldRefresh && wallet != null && transactions.isNotEmpty) {
        // Use cached data and refresh in background
        _refreshDataInBackground(userId, token);
        return;
      }

      // Fetch data in parallel
      await Future.wait([
        _fetchWallet(userId, token),
        _fetchTransactions(userId, token),
      ]);

    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchWallet(String userId, String token) async {
    try {
      wallet = await paymentService.getWallet(userId, token);
      if (wallet != null) {
        await CacheService.cacheWallet(wallet!);
      }
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  Future<void> _fetchTransactions(String userId, String token) async {
    try {
      transactions = await paymentService.getRecentTransactions(userId, token);
      if (transactions.isNotEmpty) {
        await CacheService.cacheTransactions(transactions);
      }
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  Future<void> _refreshDataInBackground(String userId, String token) async {
    isRefreshing = true;
    notifyListeners();

    try {
      await Future.wait([
        _fetchWallet(userId, token),
        _fetchTransactions(userId, token),
      ]);
    } catch (e) {
      // Silent refresh - don't show errors for background refresh
    } finally {
      isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> refreshData(String userId, String token) async {
    await _refreshDataInBackground(userId, token);
  }

  Future<void> clearCache() async {
    await CacheService.clearCache();
    wallet = null;
    transactions = [];
    notifyListeners();
  }
}
