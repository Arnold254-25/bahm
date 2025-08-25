import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bahm/providers/auth_providers.dart';

class RealEstateScreen extends StatefulWidget {
  const RealEstateScreen({Key? key}) : super(key: key);

  @override
  State<RealEstateScreen> createState() => _RealEstateScreenState();
}

class _RealEstateScreenState extends State<RealEstateScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  String? _selectedRealEstate;
  bool _isLoading = false;

  // Mock data for demonstration
  final Map<String, Map<String, dynamic>> _realEstates = {
    'Sunset Apartments': {
      'landlord': 'John Doe',
      'rentAmount': 25000.0,
      'depositAmount': 15000.0,
      'accountNumber': '1234567890',
      'bank': 'Equity Bank',
      'dueDate': '5th of every month'
    },
    'Green Valley Homes': {
      'landlord': 'Jane Smith',
      'rentAmount': 35000.0,
      'depositAmount': 17000.0,
      'accountNumber': '0987654321',
      'bank': 'KCB Bank',
      'dueDate': '10th of every month'
    },
    'Urban Heights': {
      'landlord': 'Mike Johnson',
      'rentAmount': 45000.0,
      'depositAmount': 19000.0,
      'accountNumber': '1122334455',
      'bank': 'Cooperative Bank',
      'dueDate': '15th of every month'
    }
  };

  void _searchRealEstate() {
    setState(() {
      _isLoading = true;
    });

    // Simulate search delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
        if (_realEstates.containsKey(_searchController.text)) {
          _selectedRealEstate = _searchController.text;
        } else {
          _selectedRealEstate = null;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Real estate not found')),
          );
        }
      });
    });
  }

  void _payRent() {
    if (_selectedRealEstate != null) {
      final realEstate = _realEstates[_selectedRealEstate]!;
      // Implement payment logic here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Paying rent of KES ${realEstate['rentAmount']} for $_selectedRealEstate')),
      );
    }
  }

  void _payDeposit() {
    if (_selectedRealEstate != null) {
      final realEstate = _realEstates[_selectedRealEstate]!;
      // Implement payment logic here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Paying deposit of KES ${realEstate['depositAmount']} for $_selectedRealEstate')),
      );
    }
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty && _selectedRealEstate != null) {
      final realEstate = _realEstates[_selectedRealEstate]!;
      // Implement message sending logic here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Message sent to ${realEstate['landlord']}')),
      );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Real Estate Management',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Section
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Search Real Estate',
                      labelStyle: const TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    ),
                    onSubmitted: (_) => _searchRealEstate(),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _searchRealEstate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD700),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.black)
                        : const Text('Search', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Account Details Section
            if (_selectedRealEstate != null) ...[
              Text(
                'Account Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Property', _selectedRealEstate!),
                    _buildDetailRow('Landlord', _realEstates[_selectedRealEstate]!['landlord']),
                    _buildDetailRow('Rent Amount', 'KES ${_realEstates[_selectedRealEstate]!['rentAmount']}'),
                    _buildDetailRow('Deposit Amount', 'KES ${_realEstates[_selectedRealEstate]!['depositAmount']}'),
                    _buildDetailRow('Account Number', _realEstates[_selectedRealEstate]!['accountNumber']),
                    _buildDetailRow('Bank', _realEstates[_selectedRealEstate]!['bank']),
                    _buildDetailRow('Due Date', _realEstates[_selectedRealEstate]!['dueDate']),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Payment Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _payRent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Pay Rent', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _payDeposit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Pay Deposit', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Message Section
              Text(
                'Message Landlord',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _messageController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Type your message here...',
                  labelStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _sendMessage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Send Message', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ] else if (_searchController.text.isNotEmpty && !_isLoading) ...[
              const Center(
                child: Text(
                  'No real estate found. Please try another search.',
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ),
            ] else ...[
              const Center(
                child: Text(
                  'Search for a real estate property to manage payments and communications.',
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
