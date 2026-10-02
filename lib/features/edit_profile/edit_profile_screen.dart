import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movies/core/app_avatar/app_avatar.dart';
import 'package:movies/core/storage/user_storage.dart';
import '../../core/app_colors/app_colors.dart';
import '../../core/widgets/profile/app_button.dart';
import '../../core/widgets/profile/avatar_picker.dart';
import '../../core/widgets/profile/info_filled.dart';
import '../login/login_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  static const String routeName = 'EditProfile';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final UserStorage _storage = UserStorage.instance;

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late int _avatarIndex;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _storage.name);
    _phoneController = TextEditingController(text: _storage.phone);
    _avatarIndex = _storage.avatarIndex;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final selected = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: AppColors.grey,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AvatarPicker(selectedIndex: _avatarIndex),
    );

    if (selected != null) {
      setState(() => _avatarIndex = selected);
    }
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name')),
      );
      return;
    }

    await _storage.updateProfile(
      name: name,
      phone: _phoneController.text.trim(),
      avatarIndex: _avatarIndex,
    );

    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This will delete your profile, watch list and history. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await FirebaseAuth.instance.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      final message = e.code == 'requires-recent-login'
          ? 'Please log in again, then delete your account'
          : 'Could not delete account, try again';
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      return;
    }

    await _storage.clearAll();

    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      LoginScreen.routeName,
          (route) => false,
    );
  }

  Future<void> _resetPassword() async {
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email == null) return;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset link sent to $email')),
      );
    } on FirebaseAuthException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not send reset email')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.yellow),
        title: const Text(
          'Pick Avatar',
          style: TextStyle(color: AppColors.yellow, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: _pickAvatar,
                          child: CircleAvatar(
                            radius: 72,
                            backgroundImage:
                            AssetImage(AppAvatar.avatar[_avatarIndex]),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      InfoField(
                        controller: _nameController,
                        icon: Icons.person,
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 16),
                      InfoField(
                        controller: _phoneController,
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _resetPassword,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            'Reset Password',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AppButton(
                label: 'Delete Account',
                color: AppColors.red,
                textColor: AppColors.white,
                onTap: _deleteAccount,
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Update Data',
                color: AppColors.yellow,
                textColor: AppColors.black,
                onTap: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
