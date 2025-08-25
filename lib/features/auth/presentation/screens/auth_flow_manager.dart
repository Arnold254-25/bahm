import 'package:flutter/material.dart';
import 'package:bahm/services/security_service.dart';
import 'package:bahm/controllers/auth_service.dart';
import 'package:bahm/features/home/presentation/screens/loader_screen.dart';
import 'package:bahm/features/auth/presentation/screens/login_screen.dart';
import 'package:bahm/features/home/presentation/screens/home_screen.dart';

class AuthFlowManager extends StatefulWidget {
  const AuthFlowManager({super.key});

  @override
  State<AuthFlowManager> createState() => _AuthFlowManagerState();
}

class _AuthFlowManagerState extends State<AuthFlowManager> {
  final SecurityService _securityService = SecurityService();
  final AuthService _authService = AuthService();
  bool _isChecking = true;
  bool _isLoggedIn = false;
  bool _securitySetupCompleted = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      // Check if user is logged in
      final loggedIn = await _authService.isLoggedIn();
      
      // Check if security setup is completed
      final securityCompleted = await _securityService.isSecuritySetupCompleted();

      if (mounted) {
        setState(() {
          _isLoggedIn = loggedIn;
          _securitySetupCompleted = securityCompleted;
          _isChecking = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isChecking = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // If user is logged in, go to home
    if (_isLoggedIn) {
      return const HomeScreen();
    }

    // If security setup is not completed, start with login
    // The login screen will handle routing to signup/security setup
    return const LoginPage();
  }
}
