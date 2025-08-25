import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:bahm/models/walletModel.dart';
import 'package:bahm/models/transactionModel.dart';

class CacheService {
  static const String _walletKey = 'cached_wallet';
  static const String _transactionsKey = 'cached_transactions';
  static const String _lastUpdateKey = 'last_update';

  static Future<void> cacheWallet(Wallet wallet) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_walletKey, jsonEncode(wallet.toJson()));
    await prefs.setString(_lastUpdateKey, DateTime.now().toIso8601String());
  }

  static Future<Wallet?> getCachedWallet() async {
    final prefs = await SharedPreferences.getInstance();
    final walletJson = prefs.getString(_walletKey);
    if (walletJson != null) {
      return Wallet.fromJson(jsonDecode(walletJson));
    }
    return null;
  }

  static Future<void> cacheTransactions(List<Transaction> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = transactions.map((t) => t.toJson()).toList();
    await prefs.setString(_transactionsKey, jsonEncode(transactionsJson));
  }

  static Future<List<Transaction>> getCachedTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = prefs.getString(_transactionsKey);
    if (transactionsJson != null) {
      final List<dynamic> decoded = jsonDecode(transactionsJson);
      return decoded.map((json) => Transaction.fromJson(json)).toList();
    }
    return [];
  }

  static Future<bool> shouldRefreshData() async {
    final prefs = await SharedPreferences.getInstance();
    final lastUpdate = prefs.getString(_lastUpdateKey);
    if (lastUpdate == null) return true;
    
    final lastUpdateTime = DateTime.parse(lastUpdate);
    return DateTime.now().difference(lastUpdateTime).inMinutes > 5;
  }

  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_walletKey);
    await prefs.remove(_transactionsKey);
    await prefs.remove(_lastUpdateKey);
  }
}
