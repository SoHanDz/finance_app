import 'package:finance_app/features/launch/launch.dart';
import 'package:flutter/material.dart';
import 'package:finance_app/features/auth/presentation/login_page.dart';
import 'package:finance_app/features/dashboard/presentation/dashboard_page.dart';
import 'package:finance_app/features/transactions/presentation/transaction_page.dart';

class AppRoutes {
  static const launch = '/launch';
  static const login = '/login';
  static const dashboard = '/dashboard';
  static const transactions = '/transactions';

  static Map<String, WidgetBuilder> routes = {
    launch: (context) => const LaunchPage(),
    login: (context) => const LoginPage(),
    dashboard: (context) => const DashboardPage(),
    transactions: (context) => const TransactionPage(),
  };
}
