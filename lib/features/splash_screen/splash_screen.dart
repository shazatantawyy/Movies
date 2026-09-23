import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies/core/app_colors/app_colors.dart';
import 'package:movies/core/app_images/app_images.dart';
import 'package:movies/core/app_strings/app_strings.dart';
import 'package:movies/features/onboarding_screens/onboarding_1.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "splashScreen";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();

    Timer(const Duration(seconds: 3),
        (){
      Navigator.pushReplacement(context,
          MaterialPageRoute(
              builder:
                  (context)=> const Onboarding1()
          )
      );
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Column(
        mainAxisAlignment: .center,
        children: [
          Expanded(
            child: Center(
              child: Image.asset(AppImages.centerLogo, width: 253,height: 253,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 22),
            child: Column(
              children: [
                Image.asset(
                  AppImages.downLogo,
                  width:180,
                  height: 76,
                ),
                SizedBox(height: 4,),
                Text(AppStrings.underLogo,style: GoogleFonts.poppins(
                  color: AppColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
