import 'package:finance_app/features/launch/launch.dart';
import 'package:flutter/material.dart';
import 'package:finance_app/features/auth/presentation/login_page.dart';
import 'package:finance_app/features/auth/presentation/signup_page.dart';
import 'package:finance_app/features/home/presentation/home.dart';
import 'package:finance_app/features/transactions/presentation/transaction_page.dart';

class AppRoutes {
  static const launch = '/launch';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const transactions = '/transactions';

  static Map<String, WidgetBuilder> routes = {
    launch: (context) => const LaunchPage(),
    login: (context) => const LoginPage(),
    signup: (context) => const SignupPage(),
    home: (context) => const HomePage(),
    transactions: (context) => const TransactionPage(),
  };
}
