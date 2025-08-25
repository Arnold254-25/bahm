import 'package:bahm/models/transactionModel.dart';
import 'package:bahm/models/walletModel.dart';
import 'package:bahm/config/app_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentRepository {
  final String baseUrl = AppConfig.baseUrl;

  Future<Wallet> getWallet(String userId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/wallet/$userId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return Wallet.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch wallet: ${response.body}');
    }
  }

  Future<List<Transaction>> getRecentTransactions(String userId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/transactions/$userId?limit=5'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Transaction.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch transactions: ${response.body}');
    }
  }
}
