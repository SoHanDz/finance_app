import 'package:flutter/material.dart';
import 'package:finance_app/core/config/app_router.dart';

/// Trang đăng nhập sử dụng TextField với Controller
/// Sử dụng TextField thay vì Form vì logic đơn giản, không cần validation phức tạp
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller để quản lý dữ liệu nhập vào TextField
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // Biến để toggle hiển thị/ẩn mật khẩu
  bool _obscurePassword = true;
  
  // Biến để quản lý trạng thái loading khi đăng nhập
  bool _isLoading = false;

  @override
  void dispose() {
    // Giải phóng bộ nhớ khi widget bị hủy
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Hàm xử lý đăng nhập
  /// Validate dữ liệu trước khi thực hiện đăng nhập
  Future<void> _handleLogin() async {
    // Lấy dữ liệu từ controller và trim khoảng trắng
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Validate email
    if (email.isEmpty) {
      _showSnackBar('Vui lòng nhập email hoặc tên người dùng');
      return;
    }

    // Validate email format nếu có chứa @
    if (email.contains('@') && !_isValidEmail(email)) {
      _showSnackBar('Email không hợp lệ');
      return;
    }

    // Validate password
    if (password.isEmpty) {
      _showSnackBar('Vui lòng nhập mật khẩu');
      return;
    }

    if (password.length < 6) {
      _showSnackBar('Mật khẩu phải có ít nhất 6 ký tự');
      return;
    }

    // Hiển thị loading
    setState(() {
      _isLoading = true;
    });

    // Giả lập API call (thay bằng API thực tế)
    await Future.delayed(const Duration(seconds: 1));

    // Ẩn loading
    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // Navigate đến home page
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.home,
      );
    }
  }

  /// Kiểm tra email có đúng format không
  /// Returns: true nếu email hợp lệ, false nếu không
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    return emailRegex.hasMatch(email);
  }

  /// Hiển thị thông báo lỗi
  /// [message] - Nội dung thông báo
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header section với màu xanh lá
          _buildHeader(),

          // Form section với background màu xanh nhạt
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(color: Color(0xFFE8F5F0)),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),

                    // Email/Username TextField
                    _buildEmailField(),

                    const SizedBox(height: 20),

                    // Password TextField
                    _buildPasswordField(),

                    const SizedBox(height: 32),

                    // Login Button
                    _buildLoginButton(),

                    const SizedBox(height: 16),

                    // Forgot Password Button
                    _buildForgotPasswordButton(),

                    const SizedBox(height: 8),

                    // Sign Up Button
                    _buildSignUpButton(),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build header section với logo và tên app
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: const BoxDecoration(
        color: Color(0xFF00D4AA),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 56),
          
          // Logo icon
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.trending_up,
              color: Color(0xFF00D4AA),
              size: 40,
            ),
          ),

          const SizedBox(height: 16),

          // App Name
          const Text(
            'FinWise',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFFFFF),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  /// Build Email TextField
  /// TextInputType.emailAddress - Hiển thị bàn phím email trên mobile
  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tên người dùng hoặc Email',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFB8E6D3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress, // Keyboard type cho email
            textInputAction: TextInputAction.next, // Nút next trên keyboard
            decoration: const InputDecoration(
              hintText: 'example@example.com',
              hintStyle: TextStyle(
                color: Color(0xFF999999),
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              prefixIcon: Icon(
                Icons.email_outlined,
                color: Color(0xFF666666),
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build Password TextField
  /// obscureText - Ẩn/hiện mật khẩu
  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mật khẩu',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFB8E6D3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _passwordController,
            obscureText: _obscurePassword, // Ẩn mật khẩu
            keyboardType: TextInputType.visiblePassword, // Keyboard type cho password
            textInputAction: TextInputAction.done, // Nút done trên keyboard
            onSubmitted: (_) => _handleLogin(), // Submit khi nhấn done
            decoration: InputDecoration(
              hintText: '••••••••',
              hintStyle: const TextStyle(
                color: Color(0xFF999999),
                fontSize: 16,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: Color(0xFF666666),
                size: 20,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: const Color(0xFF666666),
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build Login Button
  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleLogin, // Disable khi đang loading
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00D4AA),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 0,
        disabledBackgroundColor: const Color(0xFF00D4AA).withOpacity(0.6),
      ),
      child: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Text(
              'Đăng nhập',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }

  /// Build Forgot Password Button
  Widget _buildForgotPasswordButton() {
    return TextButton(
      onPressed: () {
        // TODO: Navigate to forgot password page
        _showSnackBar('Chức năng đang phát triển');
      },
      child: const Text(
        'Quên mật khẩu?',
        style: TextStyle(
          fontSize: 14,
          color: Color(0xFF333333),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Build Sign Up Button
  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.signup,
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFB8E6D3),
        foregroundColor: const Color(0xFF00D4AA),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 0,
      ),
      child: const Text(
        'Đăng ký',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}