import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movies/core/app_avatar/app_avatar.dart';
import 'package:movies/core/app_colors/app_colors.dart';
import 'package:movies/core/storage/user_storage.dart';
import 'package:movies/core/widgets/services/auth_button.dart';
import 'package:movies/core/widgets/services/auth_text_field.dart';
import 'package:movies/features/home/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = "Register";
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  int selectedAvatar = 0;
  bool isLoading = false;

  final List<String> avatarImages = AppAvatar.avatar.take(3).toList();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("من فضلك املأي كل الحقول المطلوبة")),
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("كلمة المرور غير متطابقة")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      await credential.user?.updateDisplayName(nameController.text.trim());

      // New account -> fresh local profile (no leftovers from a previous user).
      final storage = UserStorage.instance;
      await storage.clearAll();
      await storage.updateProfile(
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        avatarIndex: selectedAvatar,
      );

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      String message = "حدث خطأ، حاولي مرة أخرى";
      if (e.code == 'email-already-in-use') {
        message = "الإيميل ده مستخدم بالفعل";
      } else if (e.code == 'weak-password') {
        message = "كلمة المرور ضعيفة جدًا";
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
                "Register",
                style: TextStyle(
                  color: AppColors.yellow,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(avatarImages.length, (index) {
                  final isSelected = selectedAvatar == index;
                  return GestureDetector(
                    onTap: () => setState(() => selectedAvatar = index),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? AppColors.yellow : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(avatarImages[index]),
                      ),
                    ),
                  );
                }),
              ),
              const Text(
                "Avatar",
                style: TextStyle(color: AppColors.white, fontSize: 12),
              ),
              const SizedBox(height: 24),

              AuthTextField(
                hintText: "Name",
                prefixIcon: Icons.person_outline,
                controller: nameController,
              ),
              const SizedBox(height: 12),

              AuthTextField(
                hintText: "Email",
                prefixIcon: Icons.email_outlined,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),

              AuthTextField(
                hintText: "Password",
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                controller: passwordController,
              ),
              const SizedBox(height: 12),

              AuthTextField(
                hintText: "Confirm Password",
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                controller: confirmPasswordController,
              ),
              const SizedBox(height: 12),

              AuthTextField(
                hintText: "Phone Number",
                prefixIcon: Icons.phone_outlined,
                controller: phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),

              AuthButton(
                text: isLoading ? "Loading..." : "Create Account",
                onPressed: isLoading ? () {} : _createAccount,
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already Have Account ? ",
                    style: TextStyle(color: AppColors.white.withValues(alpha: 0.7)),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: AppColors.yellow,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}