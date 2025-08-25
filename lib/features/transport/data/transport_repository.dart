class TransportRepository {
  Future<List<Map<String, dynamic>>> fetchTransportServices() async {
    // Simulate fetching transport services from a data source
    await Future.delayed(const Duration(seconds: 1));
    return [
      {'id': 1, 'name': 'Matatu', 'description': 'Local minibuses'},
      {'id': 2, 'name': 'Bus', 'description': 'Long distance buses'},
      {'id': 3, 'name': 'Train', 'description': 'Railway services'},
      {'id': 4, 'name': 'Taxi', 'description': 'Private taxis'},
      {'id': 5, 'name': 'Boda Boda', 'description': 'Motorcycle taxis'},
    ];
  }

  Future<List<String>> fetchPopularRoutes() async {
    // Simulate fetching popular routes from a data source
    await Future.delayed(const Duration(seconds: 1));
    return [
      'Nairobi - Mombasa',
      'Nairobi - Kisumu',
      'Nairobi - Nakuru',
      'Nairobi - Eldoret',
      'Nairobi - Thika',
    ];
  }

  Future<Map<String, dynamic>> bookTransport(
      String serviceType, String route, int passengers) async {
    // Simulate booking transport
    await Future.delayed(const Duration(seconds: 1));
    return {
      'serviceType': serviceType,
      'route': route,
      'passengers': passengers,
      'status': 'Booked',
    };
  }

  Future<List<Map<String, dynamic>>> fetchBookingHistory() async {
    // Simulate fetching booking history
    await Future.delayed(const Duration(seconds: 1));
    return [
      {'id': 1, 'serviceType': 'Matatu', 'route': 'Nairobi - Mombasa', 'date': '2023-10-01'},
      {'id': 2, 'serviceType': 'Bus', 'route': 'Nairobi - Kisumu', 'date': '2023-10-02'},
    ];
  }
}
