import 'package:flutter/material.dart';

import '../../app_avatar/app_avatar.dart';
import '../../app_colors/app_colors.dart';

class AvatarPicker extends StatelessWidget {
  const AvatarPicker({super.key, required this.selectedIndex});

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: AppAvatar.avatar.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () => Navigator.pop(context, index),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.yellow.withValues(alpha: 0.5)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.yellow),
              ),
              child: Image.asset(AppAvatar.avatar[index]),
            ),
          );
        },
      ),
    );
  }
}
