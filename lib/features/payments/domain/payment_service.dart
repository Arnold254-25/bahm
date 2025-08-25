import 'package:bahm/models/transactionModel.dart';
import 'package:bahm/models/walletModel.dart';
import '../data/payment_repository.dart';

class PaymentService {
  final PaymentRepository repository;

  PaymentService(this.repository);

  Future<Wallet> getWallet(String userId, String token) async {
    return await repository.getWallet(userId, token);
  }

  Future<List<Transaction>> getRecentTransactions(String userId, String token) async {
    return await repository.getRecentTransactions(userId, token);
  }
}