import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movies/core/app_colors/app_colors.dart';
import 'package:movies/core/widgets/auth_button.dart';
import 'package:movies/core/widgets/auth_text_field.dart';
import 'package:movies/core/app_images/app_images.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const String routeName = "forget_password";
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> _verifyEmail() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("من فضلك اكتبي الإيميل")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم إرسال رابط إعادة تعيين كلمة المرور على إيميلك")),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String message = "حدث خطأ، حاولي مرة أخرى";
      if (e.code == 'user-not-found') {
        message = "مفيش حساب مسجل بالإيميل ده";
      } else if (e.code == 'invalid-email') {
        message = "صيغة الإيميل غير صحيحة";
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: AppColors.white),
                  ),
                ],
              ),
              const Text(
                "Forget Password",
                style: TextStyle(
                  color: AppColors.yellow,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(
                AppImages.bg10,
                height: 300,
              ),
              const SizedBox(height: 25),
              Text(
                "Enter your email and we'll send you a link to reset your password",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.white.withValues(alpha: 0.7)),
              ),
              const SizedBox(height: 32),
              AuthTextField(
                hintText: "Email",
                prefixIcon: Icons.email_outlined,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),

              AuthButton(
                text: isLoading ? "Loading..." : "Verify Email",
                onPressed: isLoading ? () {} : _verifyEmail,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}