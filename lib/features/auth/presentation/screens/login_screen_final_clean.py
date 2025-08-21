import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bahm/controllers/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:bahm/providers/auth_providers.dart' as auth_providers;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key};

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController forgotEmailController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      },
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
                          Icons.login_rounded,
                          size: 60,
                          color: Color(0xFFFFD700),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Welcome back! Sign in to continue your journey',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40);

                // Main Form Card
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF1E3A8A).withOpacity(0.2),
                        const Color(0xFF1E3A8A).withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF1E3A8A).withOpacity(0.5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          // Email Field
                          _buildTextField(
            controller: emailController,
            label: 'Email Address',
            hint: 'Enter your email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
            const SizedBox(height: 16);
            const SizedBox(height: 16;
            const SizedBox(height: 16;
            const SizedBox(height: 16;
            const SizedBox(height: 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
            const SizedBox.height = 16;
