import 'package:flutter/material.dart';
import 'package:bahm/providers/auth_providers.dart';
import 'package:provider/provider.dart';

class TransportHomeScreen extends StatefulWidget {
  const TransportHomeScreen({super.key});

  @override
  State<TransportHomeScreen> createState() => _TransportHomeScreenState();
}

class _TransportHomeScreenState extends State<TransportHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _popularRoutes = [
    'Nairobi - Mombasa',
    'Nairobi - Kisumu',
    'Nairobi - Nakuru',
    'Nairobi - Eldoret',
    'Nairobi - Thika'
  ];

  final List<Map<String, dynamic>> _transportServices = [
    {
      'icon': Icons.directions_bus,
      'title': 'Matatu',
      'color': const Color(0xFF4CAF50),
      'description': 'Local minibuses'
    },
    {
      'icon': Icons.directions_bus,
      'title': 'Bus',
      'color': const Color(0xFF2196F3),
      'description': 'Long distance buses'
    },
    {
      'icon': Icons.train,
      'title': 'Train',
      'color': const Color(0xFFFF9800),
      'description': 'Railway services'
    },
    {
      'icon': Icons.local_taxi,
      'title': 'Taxi',
      'color': const Color(0xFFE91E63),
      'description': 'Private taxis'
    },
    {
      'icon': Icons.motorcycle,
      'title': 'Boda Boda',
      'color': const Color(0xFF9C27B0),
      'description': 'Motorcycle taxis'
    },
    {
      'icon': Icons.directions_car,
      'title': 'Ride Share',
      'color': const Color(0xFF607D8B),
      'description': 'Car sharing services'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black,
              const Color(0xFF1E3A8A).withOpacity(0.1),
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Transport',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color(0xFFFFD700),
                      child: Text(
                        authProvider.user?.phone?.isNotEmpty == true
                            ? authProvider.user!.phone![0].toUpperCase()
                            : 'U',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search destinations or routes...',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.6)),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.mic, color: Colors.white.withOpacity(0.6)),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Transport Services Grid
                const Text(
                  'Transport Services',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: _transportServices.length,
                    itemBuilder: (context, index) {
                      final service = _transportServices[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigate to specific service screen
                          _showServiceDetails(service['title']);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: service['color'],
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(service['icon'], color: Colors.white, size: 32),
                              const SizedBox(height: 8),
                              Text(
                                service['title'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                service['description'],
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Popular Routes
                const Text(
                  'Popular Routes',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _popularRoutes.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: Center(
                          child: Text(
                            _popularRoutes[index],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showServiceDetails(String serviceName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        title: Text(
          '$serviceName Service',
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          'This feature is coming soon! You\'ll be able to book $serviceName services directly from the app.',
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}
