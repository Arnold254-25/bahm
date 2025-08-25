// import 'package:bahm/features/home/controllers/home_controller.dart';
// import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:bahm/providers/auth_providers.dart';
// import '../../../payments/domain/payment_service.dart';
// import '../../../../models/transactionModel.dart';

// class HomeScreenOptimized extends StatefulWidget {
//   const HomeScreenOptimized({super.key});

//   @override
//   State<HomeScreenOptimized> createState() => _HomeScreenOptimizedState();
// }

// class _HomeScreenOptimizedState extends State<HomeScreenOptimized> with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//   late HomeController _homeController;

//   @override
//   void initState() {
//     super.initState();
    
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     _homeController = Provider.of<HomeController>(context, listen: false);
    
//     if (authProvider.user != null && authProvider.token != null) {
//       final userId = authProvider.user!.uid;
//       final token = authProvider.token!;
//       if (userId.isNotEmpty) {
//         _homeController.fetchAllData(userId, token);
//       }
//     }

//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
//     );
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   Widget _buildQuickActionCard({
//     required IconData icon,
//     required String title,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 100,
//         height: 100,
//         decoration: BoxDecoration(
//           color: color,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 10,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, color: Colors.white, size: 30),
//             const SizedBox(height: 8),
//             Text(
//               title,
//               style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     if (authProvider.user == null) {
//       return Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text('Please log in to continue'),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () => Navigator.pushNamed(context, '/login'),
//                 child: const Text('Login'),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return Scaffold(
//       backgroundColor: Colors.black,
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.menu, color: Colors.white),
//           onPressed: () {},
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications_outlined, color: Colors.white),
//             onPressed: () {},
//           ),
//           GestureDetector(
//             onTap: () => Navigator.pushNamed(context, '/profile'),
//             child: Container(
//               margin: const EdgeInsets.only(right: 16),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFFFD700),
//                 shape: BoxShape.circle,
//               ),
//               child: CircleAvatar(
//                 backgroundColor: Colors.transparent,
//                 child: Text(
//                   authProvider.user!.phone?.isNotEmpty == true 
//                       ? authProvider.user!.phone![0].toUpperCase() 
//                       : 'U',
//                   style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Colors.black,
//               const Color(0xFF1E3A8A).withOpacity(0.1),
//               Colors.black,
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: RefreshIndicator(
//             onRefresh: () async {
//               final authProvider = Provider.of<AuthProvider>(context, listen: false);
//               if (authProvider.user != null && authProvider.token != null) {
//                 await _homeController.refreshData(authProvider.user!.uid, authProvider.token!);
//               }
//             },
//             child: SingleChildScrollView(
//               physics: const AlwaysScrollableScrollPhysics(),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
//                 child: FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: SlideTransition(
//                     position: _slideAnimation,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Header Section
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               'BAHM',
//                               style: TextStyle(
//                                 fontSize: 28,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             GestureDetector(
//                               onTap: () => Navigator.pushNamed(context, '/profile'),
//                               child: CircleAvatar(
//                                 backgroundColor: const Color(0xFFFFD700),
//                                 child: Text(
//                                   authProvider.user!.phone?.isNotEmpty == true 
//                                       ? authProvider.user!.phone![0].toUpperCase() 
//                                       : 'U',
//                                   style: const TextStyle(color: Colors.black),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 20),

//                         // Balance Card
//                         Consumer<HomeController>(
//                           builder: (context, controller, _) {
//                             if (controller.isLoading && controller.wallet == null) {
//                               return const Center(child: CircularProgressIndicator());
//                             }
//                             if (controller.errorMessage != null) {
//                               return Container(
//                                 padding: const EdgeInsets.all(16),
//                                 decoration: BoxDecoration(
//                                   color: Colors.red.withOpacity(0.1),
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 child: Text(
//                                   controller.errorMessage!,
//                                   style: const TextStyle(color: Colors.red),
//                                 ),
//                               );
//                             }
//                             return Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(20),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.1),
//                                     blurRadius: 20,
//                                     offset: const Offset(0, 10),
//                                   ),
//                                 ],
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(20),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Text(
//                                       'Total Balance',
//                                       style: TextStyle(fontSize: 16, color: Colors.grey),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Text(
//                                       'KES ${controller.wallet?.balance.toStringAsFixed(2) ?? '0.00'}',
//                                       style: const TextStyle(
//                                         fontSize: 32,
//                                         fontWeight: FontWeight.bold,
//                                         color: Color(0xFF1E88E5),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         const Text(
//                                           'Coupons',
//                                           style: TextStyle(fontSize: 14, color: Colors.grey),
//                                         ),
//                                         Text(
//                                           '+${controller.wallet?.loyaltyPoints.toStringAsFixed(2) ?? '0.00'}',
//                                           style: const TextStyle(fontSize: 14, color: Colors.green),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                         const SizedBox(height: 20),

//                         // Quick Actions
//                         const Text(
//                           'Quick Actions',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             _buildQuickActionCard(
//                               icon: Icons.qr_code_scanner,
//                               title: 'Scan QR',
//                               color: const Color(0xFF1E88E5),
//                               onTap: () async {
//                                 if (_homeController.canUseBiometrics) {
//                                   final authenticated = await _homeController.authenticateWithBiometrics();
//                                   if (!authenticated) {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(content: Text(_homeController.errorMessage ?? 'Authentication failed')),
//                                     );
//                                     return;
//                                   }
//                                 }
//                                 Navigator.pushNamed(context, '/qr_payment');
//                               },
//                             ),
//                             _buildQuickActionCard(
//                               icon: Icons.add_circle_outline,
//                               title: 'Add Funds',
//                               color: const Color(0xFFFFD700),
//                               onTap: () {
//                                 Navigator.pushNamed(context, '/add_funds');
//                               },
//                             ),
//                             _buildQuickActionCard(
//                               icon: Icons.send,
//                               title: 'Send Money',
//                               color: const Color(0xFF42A5F5),
//                               onTap: () async {
//                                 if (_homeController.canUseBiometrics) {
//                                   final authenticated = await _homeController.authenticateWithBiometrics();
//                                   if (!authenticated) {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(content: Text(_homeController.errorMessage ?? 'Authentication failed')),
//                                     );
//                                     return;
//                                   }
//                                 }
//                                 Navigator.pushNamed(context, '/oliver');
//                               },
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 20),

//                         // Recent Transactions
//                         const Text(
//                           'Recent Transactions',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Consumer<HomeController>(
//                           builder: (context, controller, _) {
//                             if (controller.isLoading && controller.transactions.isEmpty) {
//                               return const Center(child: CircularProgressIndicator());
//                             }
//                             if (controller.errorMessage != null) {
//                               return Container(
//                                 padding: const EdgeInsets.all(16),
//                                 decoration: BoxDecoration(
//                                   color: Colors.red.withOpacity(0.1),
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 child: Text(
//                                   controller.errorMessage!,
//                                   style: const TextStyle(color: Colors.red),
//                                 ),
//                               );
//                             }
//                             if (controller.transactions.isEmpty) {
//                               return Container(
//                                 padding: const EdgeInsets.all(20),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(15),
//                                 ),
//                                 child: const Center(
//                                   child: Text(
//                                     'No transactions yet',
//                                     style: TextStyle(color: Colors.grey),
//                                   ),
//                                 ),
//                               );
//                             }
//                             return Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(15),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.1),
//                                     blurRadius: 10,
//                                     offset: const Offset(0, 5),
//                                   ),
//                                 ],
//                               ),
//                               child: ListView.builder(
//                                 shrinkWrap: true,
//                                 physics: const NeverScrollableScrollPhysics(),
//                                 itemCount: controller.transactions.length,
//                                 itemBuilder: (context, index) {
//                                   final transaction = controller.transactions[index];
//                                   final isSent = transaction.senderId == authProvider.user!.uid;
//                                   return ListTile(
//                                     leading: CircleAvatar(
//                                       backgroundColor: isSent ? const Color(0xFF1E88E5) : const Color(0xFFFFD700),
//                                       child: const Icon(Icons.payment, color: Colors.white),
//                                     ),
//                                     title: Text(
//                                       isSent ? 'Sent to ${transaction.recipientId}' : 'Received from ${transaction.senderId}',
//                                       style: const TextStyle(fontWeight: FontWeight.bold),
//                                     ),
//                                     subtitle: Text(
//                                       '${transaction.createdAt.day}/${transaction.createdAt.month}/${transaction.createdAt.year}',
//                                       style: const TextStyle(color: Colors.grey),
//                                     ),
//                                     trailing: Text(
//                                       isSent ? '-KES ${transaction.amount.toStringAsFixed(2)}' : '+KES ${transaction.amount.toStringAsFixed(2)}',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         color: isSent ? Colors.red : Colors.green,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// extension on fb_auth.User {
//   String? get phone => this.phoneNumber;
// }
