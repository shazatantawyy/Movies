import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/api/api_manager.dart';
import 'package:movies/core/app_colors/app_colors.dart';
import 'package:movies/core/app_theme/app_theme.dart';
import 'package:movies/core/storage/user_storage.dart';
import 'package:movies/features/home/data/movies_repository.dart';
import 'package:movies/features/home/tabs/home_tab.dart';
import 'package:movies/features/onboarding_screens/onboarding_screen.dart';
import 'package:movies/features/splash_screen/splash_screen.dart';
import 'package:movies/firebase_options.dart';
import 'features/edit_profile/edit_profile_screen.dart';
import 'features/forget_password/forget_password_screen.dart';
import 'features/home/home_screen.dart';
import 'features/home/movie_details_screen.dart';
import 'features/home/profile_screen/profile_tab.dart';
import 'features/home/search_screen/search_tab.dart';
import 'features/home/tabs/explore_tab.dart';
import 'features/login/login_screen.dart';
import 'features/register/register_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserStorage.instance.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => MoviesRepository(ApiManager()),
      child: MaterialApp(
        title: 'Movies',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        initialRoute: SplashScreen.routeName,
        builder: (context, child) => ColoredBox(
          color: AppColors.black,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: child,
            ),
          ),
        ),
        routes: {
          SplashScreen.routeName: (context) => const SplashScreen(),
          OnboardingScreen.routeName: (context) => const OnboardingScreen(),
          LoginScreen.routeName: (context) => const LoginScreen(),
          ForgetPasswordScreen.routeName: (context) =>
          const ForgetPasswordScreen(),
          RegisterScreen.routeName: (context) => const RegisterScreen(),
          HomeScreen.routeName: (context) => const HomeScreen(),
          HomeTab.routeName: (context) => const HomeTab(),
          MovieDetailsScreen.routeName: (_) => const MovieDetailsScreen(),
          SearchTab.routeName: (context) => const SearchTab(),
          ExploreTab.routeName: (context) => const ExploreTab(),
          ProfileTab.routeName: (context) => const ProfileTab(),
          EditProfileScreen.routeName: (context) => const EditProfileScreen(),
        },
      ),
    );
  }
}