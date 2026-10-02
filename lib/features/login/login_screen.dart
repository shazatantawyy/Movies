import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movies/core/storage/user_storage.dart';
import 'package:movies/core/app_colors/app_colors.dart';
import 'package:movies/core/app_images/app_images.dart';
import 'package:movies/core/widgets/services/auth_button.dart';
import 'package:movies/core/widgets/services/auth_text_field.dart';
import 'package:movies/core/widgets/services/language_switch.dart';
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
  bool isLoading = false;
  bool isGoogleLoading = false;

  void _snack(String message) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(message)));


  Future<void> _saveNameAndGoHome(User? user) async {
    final storage = UserStorage.instance;

    var name = user?.displayName;
    if (name == null || name.isEmpty) {

      name = user?.email?.split('@').first;
    }

    if (name != null && name.isNotEmpty) {
      await storage.updateProfile(
        name: name,
        phone: storage.phone,
        avatarIndex: storage.avatarIndex,
      );
    }

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
    );
  }

  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _snack("Please enter your email and password");
      return;
    }

    setState(() => isLoading = true);
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      await _saveNameAndGoHome(credential.user);
    } on FirebaseAuthException catch (e) {
      var message = "Something went wrong, please try again";
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        message = "Wrong email or password";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email format";
      } else if (e.code == 'too-many-requests') {
        message = "Too many attempts, try again later";
      }
      if (mounted) _snack(message);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _loginWithGoogle() async {
    if (isGoogleLoading) return;

    setState(() => isGoogleLoading = true);
    try {
      final user = await _authService.signInWithGoogle();
      if (!mounted) return;

      if (user != null) {
        await _saveNameAndGoHome(user);
      } else {
        _snack("Google sign-in failed");
      }
    } finally {
      if (mounted) setState(() => isGoogleLoading = false);
    }
  }

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
                text: isLoading ? "Loading..." : "Login",
                onPressed: isLoading ? () {} : _login,
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
                        color: AppColors.yellow.withValues(alpha: 0.3)),
                  ),
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
                        color: AppColors.yellow.withValues(alpha: 0.3)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              AuthButton(
                text: isGoogleLoading ? "Loading..." : "Login With Google",
                backgroundColor: AppColors.yellow,
                textColor: AppColors.black,
                onPressed: isGoogleLoading ? () {} : _loginWithGoogle,
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