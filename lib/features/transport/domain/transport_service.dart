import 'package:bahm/features/transport/data/transport_repository.dart';

class TransportService {
  final TransportRepository _repository;

  TransportService(this._repository);

  Future<List<Map<String, dynamic>>> getTransportServices() async {
    try {
      return await _repository.fetchTransportServices();
    } catch (e) {
      throw Exception('Failed to fetch transport services: $e');
    }
  }

  Future<List<String>> getPopularRoutes() async {
    try {
      return await _repository.fetchPopularRoutes();
    } catch (e) {
      throw Exception('Failed to fetch popular routes: $e');
    }
  }

  Future<Map<String, dynamic>> bookTransport(
      String serviceType, String route, int passengers) async {
    try {
      return await _repository.bookTransport(serviceType, route, passengers);
    } catch (e) {
      throw Exception('Failed to book transport: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getBookingHistory() async {
    try {
      return await _repository.fetchBookingHistory();
    } catch (e) {
      throw Exception('Failed to fetch booking history: $e');
    }
  }
}
