import 'package:flutter/material.dart';

import '../../app_colors/app_colors.dart';

class InfoField extends StatelessWidget {
  const InfoField({
    super.key,
    required this.controller,
    required this.icon,
    required this.keyboardType,
  });

  final TextEditingController controller;
  final IconData icon;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.white, fontSize: 20),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.grey,
        prefixIcon: Icon(icon, color: AppColors.white, size: 28),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
