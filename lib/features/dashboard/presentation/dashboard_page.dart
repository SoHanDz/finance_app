import 'package:flutter/material.dart';
import 'package:finance_app/core/config/app_router.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00D4AA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00D4AA),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // căn trái các dòng trong column
            children: const [
              Text(
                "Chào mừng trở lại👋",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("Chào buổi sáng", style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              radius: 20, // size avatar
              backgroundColor: Colors.grey.shade200, // màu nền khung tròn
              child: IconButton(
                icon: const Icon(Icons.notifications, color: Colors.black),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text("Đi tới Transactions"),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.transactions);
          },
        ),
      ),
    );
  }
}
