import 'package:flutter/material.dart';
import 'package:finance_app/core/widgets/common_layout.dart';
import 'package:finance_app/core/widgets/content_container.dart';
import 'package:finance_app/core/widgets/main_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finance_app/core/config/app_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> _handleLogout() async {
    try {
      await FirebaseAuth.instance.signOut();

      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    } catch (e) {
      // Hiển thị lỗi nếu cần
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Đăng xuất thất bại: $e')));
    }
  }

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
              IconButton(onPressed: _handleLogout, icon: Icon(Icons.logout)),
            ],
          ),
        ),
      ),
    );
  }
}
