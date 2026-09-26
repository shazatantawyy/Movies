import 'package:flutter/material.dart';
import 'package:movies/core/app_theme/app_theme.dart';
import 'package:movies/features/onboarding_screens/onboarding_1.dart';
import 'package:movies/features/onboarding_screens/onboarding_2.dart';
import 'package:movies/features/onboarding_screens/onboarding_3.dart';
import 'package:movies/features/onboarding_screens/onboarding_4.dart';
import 'package:movies/features/splash_screen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        Onboarding1.routeName: (context) => const Onboarding1(),
        Onboarding2.routeName: (context) => const Onboarding2(),
        Onboarding3.routeName: (context) => const Onboarding3(),
        Onboarding4.routeName: (context) => const Onboarding4(),
      },
    );
  }
}