import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'core/config/app_router.dart';
import 'firebase_options.dart';
import 'features/transactions/presentation/providers/transaction_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      name: 'name-here',
      options: DefaultFirebaseOptions.currentPlatform,
    ).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        print('Firebase initialization timeout');
        throw Exception('Firebase timeout');
      },
    );
  } catch (e) {
    print('Firebase error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TransactionProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Finance Manager',
        initialRoute: AppRoutes.launch,
        routes: AppRoutes.routes,
      ),
    );
  }
}
