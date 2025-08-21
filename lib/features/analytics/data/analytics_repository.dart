import 'package:bahm/models/transactionModel.dart';
import 'package:bahm/config/app_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AnalyticsRepository {
  final String analyticsUrl = AppConfig.analyticsUrl;

  Future<List<Transaction>> fetchTransactions(String userId) async {
    final response = await http.get(
      Uri.parse('$analyticsUrl/transactions?userId=$userId'),
      headers: {'Authorization': 'Bearer your_token'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Transaction.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch transactions');
    }
  }

  Future<Map<String, dynamic>> fetchSpendingSummary(String userId) async {
    final response = await http.get(
      Uri.parse('$analyticsUrl/summary?userId=$userId'),
      headers: {'Authorization': 'Bearer your_token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch summary');
    }
  }
}
