import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bahm/providers/auth_providers.dart';
import 'package:bahm/features/split_bill/domain/split_bill_service.dart';
import 'package:bahm/features/split_bill/domain/models/split_bill_model.dart';
import 'package:bahm/features/split_bill/domain/models/participant_model.dart';

// App color constants for consistency
const Color _primaryColor = Color(0xFF1E88E5);
const Color _accentColor = Color(0xFFFFD700);
const Color _darkBlue = Color(0xFF1E3A8A);
const Color _successColor = Color(0xFF4CAF50);
const Color _errorColor = Colors.red;
const Color _surfaceColor = Color(0xFF1A1A1A);
const Color _onSurfaceColor = Colors.white;
const Color _hintColor = Color(0xFF666666);

class SplitBillScreen extends StatefulWidget {
  const SplitBillScreen({super.key});

  @override
  State<SplitBillScreen> createState() => _SplitBillScreenState();
}

class _SplitBillScreenState extends State<SplitBillScreen> {
  final SplitBillService _splitBillService = SplitBillService();
  final TextEditingController _billAmountController = TextEditingController();
  final TextEditingController _billTitleController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  SplitType _selectedSplitType = SplitType.equal;
  List<ParticipantModel> _participants = [];
  List<ParticipantModel> _availableFriends = [];
  double _totalAmount = 0.0;
  bool _isCalculating = false;

  @override
  void initState() {
    super.initState();
    _loadMockFriends();
  }

  void _loadMockFriends() {
    // Mock friends data - in real app, this would come from contacts/backend
    _availableFriends = [
      ParticipantModel(id: '1', name: 'John Doe', phoneNumber: '+254712345678', amountOwed: 0.0),
      ParticipantModel(id: '2', name: 'Jane Smith', phoneNumber: '+254723456789', amountOwed: 0.0),
      ParticipantModel(id: '3', name: 'Mike Johnson', phoneNumber: '+254734567890', amountOwed: 0.0),
      ParticipantModel(id: '4', name: 'Sarah Wilson', phoneNumber: '+254745678901', amountOwed: 0.0),
    ];
  }

  void _calculateSplit() {
    if (_totalAmount <= 0 || _participants.isEmpty) return;

    setState(() {
      _isCalculating = true;
    });

    try {
      final splitBill = _splitBillService.createSplitBill(
        title: _billTitleController.text.isNotEmpty 
            ? _billTitleController.text 
            : 'Lunch Bill',
        totalAmount: _totalAmount,
        splitType: _selectedSplitType,
        creatorId: Provider.of<AuthProvider>(context, listen: false).user!.uid,
        participants: _participants,
      );

      setState(() {
        _participants = splitBill.participants;
        _isCalculating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bill split calculated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _isCalculating = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _addParticipant(ParticipantModel friend) {
    if (!_participants.any((p) => p.id == friend.id)) {
      setState(() {
        _participants.add(friend.copyWith(amountOwed: 0.0));
      });
      _searchController.clear();
    }
  }

  void _removeParticipant(String participantId) {
    setState(() {
      _participants.removeWhere((p) => p.id == participantId);
    });
  }

  Widget _buildAmountInput() {
    return Container(
      decoration: BoxDecoration(
        color: _surfaceColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
            spreadRadius: 1,
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bill Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _onSurfaceColor,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _billTitleController,
              style: TextStyle(color: _onSurfaceColor),
              decoration: InputDecoration(
                labelText: 'Bill Title (e.g., Lunch at Restaurant)',
                labelStyle: TextStyle(color: _hintColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade700),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade700),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: _accentColor, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey.shade800.withOpacity(0.3),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _billAmountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(color: _onSurfaceColor),
              decoration: InputDecoration(
                labelText: 'Total Amount (KES)',
                labelStyle: TextStyle(color: _hintColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade700),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade700),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: _accentColor, width: 2),
                ),
                prefixText: 'KES ',
                prefixStyle: TextStyle(color: _onSurfaceColor),
                filled: true,
                fillColor: Colors.grey.shade800.withOpacity(0.3),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              onChanged: (value) {
                setState(() {
                  _totalAmount = double.tryParse(value) ?? 0.0;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSplitTypeSelector() {
    return Container(
      decoration: BoxDecoration(
        color: _surfaceColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
            spreadRadius: 1,
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Split Type',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _onSurfaceColor,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildSplitTypeChip(SplitType.equal, 'Equal Split'),
                _buildSplitTypeChip(SplitType.custom, 'Custom Amounts'),
                _buildSplitTypeChip(SplitType.percentage, 'Percentage'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSplitTypeChip(SplitType type, String label) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      selected: _selectedSplitType == type,
      onSelected: (selected) {
        setState(() {
          _selectedSplitType = type;
        });
      },
      selectedColor: _primaryColor,
      backgroundColor: Colors.grey.shade800.withOpacity(0.5),
      labelStyle: TextStyle(
        color: _selectedSplitType == type ? _onSurfaceColor : _hintColor,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: _selectedSplitType == type ? _primaryColor : Colors.transparent,
          width: 2,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  Widget _buildParticipantsSection() {
    return Container(
      decoration: BoxDecoration(
        color: _surfaceColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
            spreadRadius: 1,
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Participants',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _onSurfaceColor,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _searchController,
              style: TextStyle(color: _onSurfaceColor),
              decoration: InputDecoration(
                labelText: 'Search friends...',
                labelStyle: TextStyle(color: _hintColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade700),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade700),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: _accentColor, width: 2),
                ),
                suffixIcon: Icon(Icons.search, color: _hintColor),
                filled: true,
                fillColor: Colors.grey.shade800.withOpacity(0.3),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            SizedBox(height: 16),
            if (_availableFriends.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableFriends.map((friend) {
                  return FilterChip(
                    label: Text(
                      friend.name,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onSelected: (_) => _addParticipant(friend),
                    backgroundColor: _primaryColor.withOpacity(0.2),
                    labelStyle: TextStyle(color: _primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: _primaryColor.withOpacity(0.3)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  );
                }).toList(),
              ),
            SizedBox(height: 16),
            if (_participants.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Participants:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _onSurfaceColor,
                    ),
                  ),
                  SizedBox(height: 12),
                  ..._participants.map((participant) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _primaryColor,
                          child: Text(
                            participant.name[0],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          participant.name,
                          style: TextStyle(
                            color: _onSurfaceColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: participant.amountOwed > 0
                            ? Text(
                                'KES ${participant.amountOwed.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: _accentColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                        trailing: IconButton(
                          icon: Icon(Icons.remove_circle, color: _errorColor),
                          onPressed: () => _removeParticipant(participant.id),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      decoration: BoxDecoration(
        color: _surfaceColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
            spreadRadius: 1,
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _calculateSplit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: _onSurfaceColor,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  shadowColor: Colors.black.withOpacity(0.3),
                ),
                child: _isCalculating
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: _onSurfaceColor,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Calculate Split',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement send requests functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Send requests feature coming soon!'),
                      backgroundColor: _surfaceColor,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _successColor,
                  foregroundColor: _onSurfaceColor,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  shadowColor: Colors.black.withOpacity(0.3),
                ),
                child: Text(
                  'Send Requests',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Split Bill',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black,
              Color(0xFF1E3A8A).withOpacity(0.1),
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildAmountInput(),
                  SizedBox(height: 16),
                  _buildSplitTypeSelector(),
                  SizedBox(height: 16),
                  _buildParticipantsSection(),
                  SizedBox(height: 16),
                  _buildActionButtons(),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
