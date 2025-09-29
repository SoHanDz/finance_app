import 'package:flutter/material.dart';
import 'package:finance_app/core/widgets/common_layout.dart';
import 'package:finance_app/core/widgets/content_container.dart';
import 'package:finance_app/core/widgets/main_layout.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 3,
      child: CommonLayout(
        title: 'Thông tin cá nhân',
        child: ContentContainer(
          child: Column(
            children: [
              Text('Thông tin cá nhân'),
              
            ],
          ),
        ),
      ),
    );
  }
}