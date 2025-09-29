import 'package:flutter/material.dart';
import 'package:finance_app/core/widgets/common_layout.dart';
import 'package:finance_app/core/widgets/content_container.dart';
import 'package:finance_app/core/widgets/main_layout.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: CommonLayout(
        title: 'Thông báo',
        child: ContentContainer(
          child: Column(
            children: [
              Text('Notifications'),
              // Add your notifications widgets here
            ],
          ),
        ),
      ),
    );
  }
}