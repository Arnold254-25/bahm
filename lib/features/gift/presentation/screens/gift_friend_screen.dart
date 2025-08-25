import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bahm/providers/auth_providers.dart';

class GiftFriendScreen extends StatefulWidget {
  const GiftFriendScreen({super.key});

  @override
  State<GiftFriendScreen> createState() => _GiftFriendScreenState();
}

class _GiftFriendScreenState extends State<GiftFriendScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedGiftType = 'dinner';
  String _recipientPhone = '';
  double _amount = 0.0;
  String _appreciationMessage = '';
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Available gift types
  final List<Map<String, dynamic>> _giftTypes = [
    {'value': 'dinner', 'label': 'Dinner', 'icon': Icons.restaurant, 'color': Color(0xFFE91E63)},
    {'value': 'lunch', 'label': 'Lunch', 'icon': Icons.lunch_dining, 'color': Color(0xFFFF9800)},
    {'value': 'trip', 'label': 'Paid Trip', 'icon': Icons.flight, 'color': Color(0xFF2196F3)},
    {'value': 'shoes', 'label': 'Shoes', 'icon': Icons.shopping_bag, 'color': Color(0xFF4CAF50)},
    {'value': 'clothes', 'label': 'Clothes', 'icon': Icons.checkroom, 'color': Color(0xFF9C27B0)},
    {'value': 'electronics', 'label': 'Electronics', 'icon': Icons.phone_iphone, 'color': Color(0xFF607D8B)},
    {'value': 'books', 'label': 'Books', 'icon': Icons.menu_book, 'color': Color(0xFF795548)},
    {'value': 'custom', 'label': 'Custom Gift', 'icon': Icons.card_giftcard, 'color': Color(0xFFFFD700)},
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _messageController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitGift() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // Here you would typically send the gift data to your backend
      final selectedGift = _giftTypes.firstWhere((gift) => gift['value'] == _selectedGiftType);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gift sent successfully! ${selectedGift['label']} for KES $_amount'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Navigate back after successful submission
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Gift a Friend',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
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
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gift Type Selection
                    const Text(
                      'Choose Gift Type',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _giftTypes.length,
                        itemBuilder: (context, index) {
                          final gift = _giftTypes[index];
                          final isSelected = _selectedGiftType == gift['value'];
                          
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedGiftType = gift['value'];
                              });
                            },
                            child: Container(
                              width: 80,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? gift['color'].withOpacity(0.8)
                                    : gift['color'].withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                                border: isSelected
                                    ? Border.all(color: Colors.white, width: 2)
                                    : null,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(gift['icon'], color: Colors.white, size: 24),
                                  const SizedBox(height: 8),
                                  Text(
                                    gift['label'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
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

                    // Recipient Phone Number
                    TextFormField(
                      controller: _phoneController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Friend's Phone Number",
                        labelStyle: const TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white54),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white54),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        prefixIcon: const Icon(Icons.phone, color: Colors.white54),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter phone number';
                        }
                        if (value.length < 10) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                      onSaved: (value) => _recipientPhone = value!,
                    ),
                    const SizedBox(height: 16),

                    // Amount
                    TextFormField(
                      controller: _amountController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Amount (KES)',
                        labelStyle: const TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white54),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white54),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        prefixIcon: const Icon(Icons.attach_money, color: Colors.white54),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter amount';
                        }
                        if (double.tryParse(value) == null || double.parse(value) <= 0) {
                          return 'Please enter a valid amount';
                        }
                        return null;
                      },
                      onSaved: (value) => _amount = double.parse(value!),
                    ),
                    const SizedBox(height: 16),

                    // Appreciation Message
                    TextFormField(
                      controller: _messageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Appreciation Message',
                        labelStyle: const TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white54),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white54),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        prefixIcon: const Icon(Icons.message, color: Colors.white54),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please write an appreciation message';
                        }
                        return null;
                      },
                      onSaved: (value) => _appreciationMessage = value!,
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitGift,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE91E63),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Send Gift',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    // Current User Info
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white54),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xFFFFD700),
                            child: Text(
                              authProvider.user?.phone?.isNotEmpty == true 
                                  ? authProvider.user!.phone![0].toUpperCase() 
                                  : 'U',
                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'From: ${authProvider.user?.phone ?? 'Your account'}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Gift will be sent from your BAHM account',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
