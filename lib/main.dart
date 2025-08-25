import 'package:bahm/features/auth/presentation/screens/login_screen.dart';
import 'package:bahm/features/auth/presentation/screens/signup_screen.dart';
import 'package:bahm/features/auth/presentation/screens/security_setup_screen.dart';
import 'package:bahm/features/auth/presentation/screens/auth_flow_manager.dart';
import 'package:bahm/features/home/controllers/home_controller.dart';
import 'package:bahm/features/home/presentation/screens/home_screen.dart';
import 'package:bahm/features/home/presentation/screens/loader_screen.dart';
import 'package:bahm/features/gift/presentation/screens/gift_friend_screen.dart';
import 'package:bahm/features/split_bill/presentation/screens/split_bill_screen.dart';
import 'package:bahm/features/transport/presentation/screens/transport_home_screen.dart';
import 'package:bahm/features/education/presentation/screens/education_screen.dart';
import 'package:bahm/features/real_estate/presentation/screens/real_estate_screen.dart';
import 'package:bahm/features/crypto/presentation/screens/crypto_screen.dart';
import 'package:bahm/features/payments/data/payment_repository.dart';
import 'package:bahm/features/payments/domain/payment_service.dart';
import 'package:bahm/firebase_options.dart';
import 'package:bahm/models/userModel.dart';
import 'package:bahm/providers/auth_providers.dart';
import 'package:bahm/providers/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox('authBox');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        Provider(create: (context) => PaymentService(PaymentRepository())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bahm',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
          useMaterial3: true,
        ),
        initialRoute: '/loader',
        routes: {
          '/': (context) => const AuthFlowManager(),
          '/loader': (context) => const LoaderScreen(),
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignupPage(),
          '/security-setup': (context) {
            final args = ModalRoute.of(context)?.settings.arguments;
            return SecuritySetupScreen(user: args is UserModel ? args : null);
          },
          '/home': (context) => ChangeNotifierProvider<HomeController>(
            create: (context) => HomeController(
              Provider.of<PaymentService>(context, listen: false),
            ),
            child: const HomeScreen(),
          ),
          '/transports': (context) => const TransportHomeScreen(),
          '/gift_friend': (context) => const GiftFriendScreen(),
          '/split_bill': (context) => const SplitBillScreen(),
          '/real_estate': (context) => const RealEstateScreen(),
          '/education': (context) => ChangeNotifierProvider<HomeController>(
            create: (context) => HomeController(
              Provider.of<PaymentService>(context, listen: false),
            ),
            child: const EducationScreen(),
          ),
          '/crypto': (context) => const CryptoScreen(),
        },
      ),
    );
  }
}
