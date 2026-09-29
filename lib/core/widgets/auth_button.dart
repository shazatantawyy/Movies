import 'package:flutter/material.dart';
import 'package:movies/core/app_colors/app_colors.dart';
class AuthButton extends StatelessWidget{
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;

  const AuthButton({
  super.key,
  required this.text,
  required this.onPressed,
  this.backgroundColor = AppColors.yellow,
  this.textColor = AppColors.black,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child:  ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),

          ),
          child: Text(
             text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
      ),

    );
  }

}