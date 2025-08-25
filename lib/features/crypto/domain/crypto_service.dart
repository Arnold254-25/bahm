import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bahm/models/crypto_model.dart';
import 'package:bahm/config/app_config.dart';

class CryptoService {
  final String _baseUrl = 'https://api.coingecko.com/api/v3';
  final String _backendBaseUrl = AppConfig.backendBaseUrl;

  Future<List<CryptoCurrency>> fetchCryptocurrencies() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=50&page=1&sparkline=false'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        // Process the data to use proxied image URLs
        final List<CryptoCurrency> cryptocurrencies = data.map((json) {
          final crypto = CryptoCurrency.fromJson(json);
          
          // Replace CoinGecko image URL with proxied URL
          if (crypto.image.contains('assets.coingecko.com')) {
            final imagePath = crypto.image.replaceFirst('https://assets.coingecko.com/coins/images/', '');
            final proxiedImage = '$_backendBaseUrl/api/crypto/image/$imagePath';
            return crypto.copyWith(image: proxiedImage);
          }
          
          return crypto;
        }).toList();
        
        return cryptocurrencies;
      } else {
        throw Exception('Failed to load cryptocurrencies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch cryptocurrencies: $e');
    }
  }

  Future<CryptoCurrency> fetchCryptoDetails(String id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/coins/$id'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final crypto = CryptoCurrency.fromJson(data);
        
        // Replace CoinGecko image URL with proxied URL
        if (crypto.image.contains('assets.coingecko.com')) {
          final imagePath = crypto.image.replaceFirst('https://assets.coingecko.com/coins/images/', '');
          final proxiedImage = '$_backendBaseUrl/api/crypto/image/$imagePath';
          return crypto.copyWith(image: proxiedImage);
        }
        
        return crypto;
      } else {
        throw Exception('Failed to load cryptocurrency details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch cryptocurrency details: $e');
    }
  }

  Future<Map<String, dynamic>> getExchangeRates() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/exchange_rates'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load exchange rates: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch exchange rates: $e');
    }
  }

  Future<double> convertCurrency(String from, String to, double amount) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/simple/price?ids=$from&vs_currencies=$to'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rate = data[from][to];
        return amount * rate;
      } else {
        throw Exception('Failed to convert currency: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to convert currency: $e');
    }
  }

  Future<void> buyCrypto(String cryptoId, double amount, double price) async {
    // Implement buy logic here - this would typically interact with your backend
    // For now, we'll just simulate a successful transaction
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<void> sellCrypto(String cryptoId, double amount, double price) async {
    // Implement sell logic here - this would typically interact with your backend
    // For now, we'll just simulate a successful transaction
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<void> convertMoneyToCrypto(String fromCurrency, String toCrypto, double amount) async {
    try {
      final convertedAmount = await convertCurrency(fromCurrency, toCrypto, amount);
      // Implement the actual conversion logic with your backend
      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      throw Exception('Failed to convert money to crypto: $e');
    }
  }

  Future<Map<String, dynamic>> getPortfolio(String userId) async {
    // Implement portfolio retrieval logic
    // This would typically fetch from your backend database
    return {
      'totalValue': 0.0,
      'totalInvestment': 0.0,
      'holdings': {},
      'profitLoss': 0.0,
      'profitLossPercentage': 0.0,
    };
  }
}
