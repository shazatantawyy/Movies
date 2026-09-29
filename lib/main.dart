import 'package:flutter/material.dart';
import 'package:movies/core/app_theme/app_theme.dart';
import 'package:movies/features/onboarding_screens/onboarding_screen.dart';
import 'package:movies/features/splash_screen/splash_screen.dart';
import 'package:movies/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async{
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
options: DefaultFirebaseOptions.currentPlatform,
);
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
        SplashScreen.routeName:(context) => const OnboardingScreen(),
      }
    );
  }
}