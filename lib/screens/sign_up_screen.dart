import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';
import 'result_screen.dart';

class SignUpScreen extends StatefulWidget {
  final List<Map<String, String>> selectedItems;

  const SignUpScreen({
    super.key,
    required this.selectedItems,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
      _showError('모든 항목을 입력해주세요');
      return;
    }

    if (password != confirm) {
      _showError('비밀번호가 일치하지 않습니다');
      return;
    }

    if (password.length < 6) {
      _showError('비밀번호는 6자 이상이어야 합니다');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // feed 선택 데이터 Firestore 저장
      final uid = credential.user!.uid;
      final batch = FirebaseFirestore.instance.batch();

      for (final item in widget.selectedItems) {
        final ref = FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('feed_selections')
            .doc();

        batch.set(ref, {
          'image': item['image'],
          'tag': item['tag'],
          'timestamp': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const ResultScreen(
              likeCount: 0,
              isInitial: true,
            ),
          ),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = '회원가입에 실패했습니다';

      if (e.code == 'email-already-in-use') {
        message = '이미 사용 중인 이메일입니다';
      } else if (e.code == 'invalid-email') {
        message = '이메일 형식이 올바르지 않습니다';
      } else if (e.code == 'weak-password') {
        message = '비밀번호가 너무 약합니다';
      }

      _showError(message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[400],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 3),

              const Text(
                'SWIFIT',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '회원가입하고 취향 탐색을 시작하세요',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const Spacer(flex: 1),

              _buildTextField(
                controller: _emailController,
                hint: '이메일',
              ),
              const SizedBox(height: 12),

              _buildTextField(
                controller: _passwordController,
                hint: '비밀번호',
                obscure: _obscurePassword,
                onToggle: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
              const SizedBox(height: 12),

              _buildTextField(
                controller: _confirmPasswordController,
                hint: '비밀번호 확인',
                obscure: _obscureConfirm,
                onToggle: () {
                  setState(() => _obscureConfirm = !_obscureConfirm);
                },
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          '계정 생성하기',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    text: '이미 계정이 있으신가요? ',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                    children: const [
                      TextSpan(
                        text: '로그인',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    VoidCallback? onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          suffixIcon: onToggle != null
              ? IconButton(
                  icon: Icon(
                    obscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.grey[400],
                  ),
                  onPressed: onToggle,
                )
              : null,
        ),
      ),
    );
  }
}
