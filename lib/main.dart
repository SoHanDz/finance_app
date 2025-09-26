import 'package:flutter/material.dart';
import 'core/config/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finance Manager',
      initialRoute: AppRoutes.launch, // Trang bắt đầu
      routes: AppRoutes.routes,
    );
  }
}
