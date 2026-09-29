import 'package:flutter/material.dart';
import 'package:movies/core/app_colors/app_colors.dart';

class LanguageSwitch extends StatelessWidget {
  final bool isEnglish;
  final ValueChanged<bool> onChanged;
  final String enFlag;
  final String arFlag;

  const LanguageSwitch({
    super.key,
    required this.isEnglish,
    required this.onChanged,
    required this.enFlag,
    required this.arFlag,
  });

  @override
  Widget build(BuildContext context) {
    const double width = 90.72;
    const double height = 38.08;
    const double knob = height - 3; // مطروح منها الـ border
    const double flagSize = 26;

    return GestureDetector(
      onTap: () => onChanged(!isEnglish),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height),
          border: Border.all(color: AppColors.yellow, width: 1.5),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [

            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              alignment:
              isEnglish ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                width: knob,
                height: knob,
                decoration: const BoxDecoration(
                  color: AppColors.yellow,
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _flag(enFlag, knob, flagSize),
                _flag(arFlag, knob, flagSize),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _flag(String path, double slot, double size) {
    return SizedBox(
      width: slot,
      height: slot,
      child: Center(
        child: ClipOval(
          child: Image.asset(path, width: size, height: size, fit: BoxFit.cover),
        ),
      ),
    );
  }
}