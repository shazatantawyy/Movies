import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.color,
    required this.textColor,
    required this.onTap,
    this.icon,
    this.height = 54,
  });

  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;
  final IconData? icon;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: TextStyle(color: textColor, fontSize: 20)),
              if (icon != null) ...[
                const SizedBox(width: 8),
                Icon(icon, color: textColor),
              ],
            ],
          ),
        ),
      ),
    );
  }
}