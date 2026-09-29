import 'package:flutter/material.dart';
import 'package:movies/core/app_colors/app_colors.dart';
import 'package:movies/core/app_images/app_images.dart';
import 'package:movies/core/widgets/auth_button.dart';
import 'package:movies/core/widgets/auth_text_field.dart';
import 'package:movies/core/widgets/language_switch.dart';
import 'package:movies/core/widgets/services/auth_service.dart';
import 'package:movies/features/forget_password/forget_password_screen.dart';
import 'package:movies/features/home/home_screen.dart';
import 'package:movies/features/register/register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "login";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool isEnglish = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
              Image.asset(
                AppImages.centerLogo,
                height: 200,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              AuthTextField(
                hintText: "Email",
                prefixIcon: Icons.email_outlined,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),

              AuthTextField(
                hintText: "Password",
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                controller: passwordController,
              ),
              const SizedBox(height: 8),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgetPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Forget Password ?",
                    style: TextStyle(color: AppColors.yellow),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              AuthButton(
                text: "Login",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't Have Account ? ",
                    style: TextStyle(
                        color: AppColors.white.withValues(alpha: 0.7)),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Create One",
                      style: TextStyle(
                        color: AppColors.yellow,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                      child: Divider(
                          color: AppColors.yellow.withValues(alpha: 0.3))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "OR",
                      style: TextStyle(
                          color: AppColors.yellow.withValues(alpha: 0.5)),
                    ),
                  ),
                  Expanded(
                      child: Divider(
                          color: AppColors.yellow.withValues(alpha: 0.3))),
                ],
              ),
              const SizedBox(height: 20),

              AuthButton(
                text: "Login With Google",
                backgroundColor: AppColors.yellow,
                textColor: AppColors.black,
                onPressed: () async {
                  final user = await _authService.signInWithGoogle();
                  if (!context.mounted) return;
                  if (user != null) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("فشل تسجيل الدخول بجوجل")),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),

              Center(
                child: LanguageSwitch(
                  isEnglish: isEnglish,
                  enFlag: AppImages.bg11,
                  arFlag: AppImages.bg12,
                  onChanged: (value) {
                    setState(() => isEnglish = value);

                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}