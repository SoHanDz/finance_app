import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:finance_app/core/config/app_router.dart';

/// Trang đăng ký sử dụng Form và TextFormField
/// Sử dụng Form để quản lý validation tập trung và tự động
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // GlobalKey để quản lý Form và validation
  final _formKey = GlobalKey<FormState>();
  
  // Controllers để quản lý dữ liệu input
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  // Biến để toggle hiển thị/ẩn mật khẩu
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  // Biến để quản lý trạng thái loading
  bool _isLoading = false;

  @override
  void dispose() {
    // Giải phóng bộ nhớ khi widget bị hủy
    _fullNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _dobController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Hàm chọn ngày sinh
  /// Hiển thị DatePicker và cập nhật vào TextField
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)), // Mặc định 18 tuổi
      firstDate: DateTime(1900), // Năm sinh tối thiểu
      lastDate: DateTime.now(), // Không chọn ngày trong tương lai
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF00D4AA),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        // Format: DD/MM/YYYY
        _dobController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  /// Hàm xử lý đăng ký
  /// Validate form và thực hiện đăng ký nếu hợp lệ
  Future<void> _handleSignup() async {
    // Validate form sử dụng GlobalKey
    if (_formKey.currentState!.validate()) {
      // Hiển thị loading
      setState(() {
        _isLoading = true;
      });

      // Giả lập API call (thay bằng API thực tế)
      await Future.delayed(const Duration(seconds: 2));

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
  }

  /// Validator cho Full Name
  /// Returns: null nếu hợp lệ, String error message nếu không hợp lệ
  String? _validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập họ tên';
    }
    if (value.trim().length < 2) {
      return 'Họ tên phải có ít nhất 2 ký tự';
    }
    // Kiểm tra chỉ chứa chữ cái và khoảng trắng
    if (!RegExp(r'^[a-zA-ZÀ-ỹ\s]+$').hasMatch(value)) {
      return 'Họ tên chỉ được chứa chữ cái';
    }
    return null;
  }

  /// Validator cho Email
  /// Returns: null nếu hợp lệ, String error message nếu không hợp lệ
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập email';
    }
    // Regex pattern cho email
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  /// Validator cho Mobile Number
  /// Returns: null nếu hợp lệ, String error message nếu không hợp lệ
  String? _validateMobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập số điện thoại';
    }
    // Loại bỏ các ký tự không phải số
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digitsOnly.length < 10) {
      return 'Số điện thoại phải có ít nhất 10 chữ số';
    }
    if (digitsOnly.length > 11) {
      return 'Số điện thoại không được quá 11 chữ số';
    }
    return null;
  }

  /// Validator cho Date of Birth
  /// Returns: null nếu hợp lệ, String error message nếu không hợp lệ
  String? _validateDOB(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng chọn ngày sinh';
    }
    
    // Parse date DD/MM/YYYY
    try {
      final parts = value.split('/');
      if (parts.length != 3) {
        return 'Định dạng ngày không hợp lệ';
      }
      
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      
      final dob = DateTime(year, month, day);
      final now = DateTime.now();
      final age = now.year - dob.year;
      
      // Kiểm tra tuổi tối thiểu 13
      if (age < 13) {
        return 'Bạn phải đủ 13 tuổi để đăng ký';
      }
      
      // Kiểm tra không quá 120 tuổi
      if (age > 120) {
        return 'Ngày sinh không hợp lệ';
      }
    } catch (e) {
      return 'Ngày sinh không hợp lệ';
    }
    
    return null;
  }

  /// Validator cho Password
  /// Returns: null nếu hợp lệ, String error message nếu không hợp lệ
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }
    if (value.length > 50) {
      return 'Mật khẩu không được quá 50 ký tự';
    }
    // Kiểm tra có ít nhất 1 chữ cái và 1 số
    if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
      return 'Mật khẩu phải có ít nhất 1 chữ cái';
    }
    if (!RegExp(r'\d').hasMatch(value)) {
      return 'Mật khẩu phải có ít nhất 1 số';
    }
    return null;
  }

  /// Validator cho Confirm Password
  /// Returns: null nếu hợp lệ, String error message nếu không hợp lệ
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng xác nhận mật khẩu';
    }
    if (value != _passwordController.text) {
      return 'Mật khẩu xác nhận không khớp';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00D4AA),
      body: SafeArea(
        child: Column(
          children: [
            // Header section
            _buildHeader(),

            // Form section với ScrollView
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5F0),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey, // Gán GlobalKey cho Form
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),

                        // Full Name field
                        _buildFullNameField(),

                        const SizedBox(height: 20),

                        // Email field
                        _buildEmailField(),

                        const SizedBox(height: 20),

                        // Mobile Number field
                        _buildMobileField(),

                        const SizedBox(height: 20),

                        // Date of Birth field
                        _buildDOBField(),

                        const SizedBox(height: 20),

                        // Password field
                        _buildPasswordField(),

                        const SizedBox(height: 20),

                        // Confirm Password field
                        _buildConfirmPasswordField(),

                        const SizedBox(height: 24),

                        // Terms and Privacy text
                        _buildTermsText(),

                        const SizedBox(height: 24),

                        // Sign Up Button
                        _buildSignUpButton(),

                        const SizedBox(height: 16),

                        // Login link
                        _buildLoginLink(),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build header section
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: const Column(
        children: [
          SizedBox(height: 20),
          Text(
            'Đăng ký',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  /// Build Full Name TextFormField
  /// TextInputType.name - Keyboard type cho tên
  /// TextCapitalization.words - Tự động viết hoa chữ cái đầu mỗi từ
  Widget _buildFullNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Họ tên',
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
          child: TextFormField(
            controller: _fullNameController,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            validator: _validateFullName,
            decoration: const InputDecoration(
              hintText: 'Nguyễn Văn A',
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
                Icons.person_outline,
                color: Color(0xFF666666),
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build Email TextFormField
  /// TextInputType.emailAddress - Keyboard type cho email
  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email',
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
          child: TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: _validateEmail,
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

  /// Build Mobile Number TextFormField
  /// TextInputType.phone - Keyboard type cho số điện thoại
  /// FilteringTextInputFormatter.digitsOnly - Chỉ cho phép nhập số
  Widget _buildMobileField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Số điện thoại',
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
          child: TextFormField(
            controller: _mobileController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            validator: _validateMobile,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly, // Chỉ cho phép nhập số
              LengthLimitingTextInputFormatter(11), // Giới hạn 11 số
            ],
            decoration: const InputDecoration(
              hintText: '0901234567',
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
                Icons.phone_outlined,
                color: Color(0xFF666666),
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build Date of Birth TextFormField
  /// readOnly: true - Không cho phép nhập trực tiếp, chỉ chọn từ DatePicker
  Widget _buildDOBField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ngày sinh',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFB8E6D3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextFormField(
              controller: _dobController,
              readOnly: true, // Chỉ đọc, không cho phép nhập
              validator: _validateDOB,
              decoration: const InputDecoration(
                hintText: 'DD / MM / YYYY',
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
                  Icons.cake_outlined,
                  color: Color(0xFF666666),
                  size: 20,
                ),
                suffixIcon: Icon(
                  Icons.calendar_today_outlined,
                  color: Color(0xFF666666),
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build Password TextFormField
  /// TextInputType.visiblePassword - Keyboard type cho password
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
          child: TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
            validator: _validatePassword,
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
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
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

  /// Build Confirm Password TextFormField
  /// obscureText - Ẩn/hiện mật khẩu xác nhận
  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Xác nhận mật khẩu',
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
          child: TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            validator: _validateConfirmPassword,
            onFieldSubmitted: (_) => _handleSignup(), // Submit khi nhấn done
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
                  _obscureConfirmPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: const Color(0xFF666666),
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build Terms and Privacy text
  Widget _buildTermsText() {
    return const Text(
      'Bằng cách đăng kí, bạn sẽ chấp nhận điều khoản sử dụng của chúng tôi',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 12,
        color: Color(0xFF666666),
        height: 1.4,
      ),
    );
  }

  /// Build Sign Up Button
  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleSignup, // Disable khi đang loading
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
              'Đăng ký',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }

  /// Build Login link
  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Đã có tài khoản? ',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.login,
            );
          },
          child: const Text(
            'Đăng nhập',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF00D4AA),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}