import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bahm/models/userModel.dart';
import 'package:bahm/services/security_service.dart';

class SecuritySetupScreen extends StatefulWidget {
  final UserModel? user;
  
  const SecuritySetupScreen({
    super.key,
    this.user,
  });

  @override
  State<SecuritySetupScreen> createState() => _SecuritySetupScreenState();
}

class _SecuritySetupScreenState extends State<SecuritySetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  final SecurityService _securityService = SecurityService();
  bool _obscurePin = true;
  bool _obscureConfirmPin = true;
  bool _biometricEnabled = false;
  bool _biometricAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricSupport();
  }

  Future<void> _checkBiometricSupport() async {
    try {
      final biometricStatus = await _securityService.checkBiometricStatus();
      setState(() {
        _biometricAvailable = biometricStatus == BiometricStatus.available;
      });
      
      // Debug log
      debugPrint('Biometric status: $biometricStatus');
    } catch (e) {
      debugPrint('Error checking biometric support: $e');
      setState(() {
        _biometricAvailable = false;
      });
    }
  }

  Future<void> _handleSetup() async {
    if (_formKey.currentState!.validate()) {
      if (_pinController.text != _confirmPinController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PINs do not match. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final securityService = SecurityService();
      await securityService.storePin(_pinController.text);
      await securityService.setBiometricEnabled(_biometricEnabled);
      await securityService.setSecuritySetupCompleted(true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Security setup completed! Please login to continue.'),
          backgroundColor: Color(0xFF1E3A8A),
        ),
      );

      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Security Setup',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF1E3A8A),
                                Color(0xFF3B82F6),
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF1E3A8A).withOpacity(0.5),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.security_rounded,
                            size: 60,
                            color: Color(0xFFFFD700),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Secure Your BAHM Account',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Set up your security preferences to protect your payments',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  _buildSectionTitle('Security PIN'),
                  const SizedBox(height: 16),
                  _buildPinField(
                    controller: _pinController,
                    label: 'Create 6-digit PIN',
                    obscureText: _obscurePin,
                    toggleObscure: () => setState(() => _obscurePin = !_obscurePin),
                  ),
                  const SizedBox(height: 16),
                  _buildPinField(
                    controller: _confirmPinController,
                    label: 'Confirm 6-digit PIN',
                    obscureText: _obscureConfirmPin,
                    toggleObscure: () => setState(() => _obscureConfirmPin = !_obscureConfirmPin),
                  ),
                  const SizedBox(height: 32),

                  _buildSectionTitle('Additional Security'),
                  const SizedBox(height: 16),
                  _buildSecurityOption(
                    icon: Icons.fingerprint,
                    title: 'Biometric Authentication',
                    subtitle: 'Use fingerprint or face recognition',
                    value: _biometricEnabled,
                    onChanged: _biometricAvailable
                        ? (value) => setState(() => _biometricEnabled = value)
                        : null,
                  ),
                  const SizedBox(height: 40),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF1E3A8A).withOpacity(0.2),
                          const Color(0xFFFFD700).withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF1E3A8A).withOpacity(0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Color(0xFFFFD700)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Your security settings can be changed later in account settings',
                            style: TextStyle(
                              color: Colors.grey[300],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD700),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 8,
                        shadowColor: const Color(0xFFFFD700).withOpacity(0.3),
                      ),
                      onPressed: _handleSetup,
                      child: const Text(
                        'Complete Security Setup',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildPinField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback toggleObscure,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1E3A8A).withOpacity(0.2),
            const Color(0xFF1E3A8A).withOpacity(0.1),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF1E3A8A).withOpacity(0.5),
        ),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(6),
        ],
        style: const TextStyle(color: Colors.white, fontSize: 18),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: const Color(0xFFFFD700),
            ),
            onPressed: toggleObscure,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a PIN';
          }
          if (value.length != 6) {
            return 'PIN must be 6 digits';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSecurityOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1E3A8A).withOpacity(0.2),
            const Color(0xFF1E3A8A).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF1E3A8A).withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFFD700),
                Color(0xFFF59E0B),
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.black, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey[400], fontSize: 14),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFFFFD700),
          activeTrackColor: const Color(0xFFFFD700).withOpacity(0.3),
          inactiveTrackColor: Colors.grey[800],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }
}
