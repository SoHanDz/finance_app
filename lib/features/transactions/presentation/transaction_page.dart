import 'package:flutter/material.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transactions")),
      body: Center(
        child: ElevatedButton(
          child: const Text("Quay lại"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
