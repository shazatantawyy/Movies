import 'package:flutter/material.dart';
import 'package:movies/features/home/tabs/explore_tab.dart';
import 'package:movies/features/home/tabs/home_tab.dart';
import 'package:movies/features/home/profile_screen/profile_tab.dart';
import 'package:movies/features/home/search_screen/search_tab.dart';
import '../../core/app_colors/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = 'Home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final List<Widget> screens = const [
    HomeTab(),
    SearchTab(),
    ExploreTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(15),
        height: 75,
        decoration: BoxDecoration(
          color: AppColors.grey,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navIcon(Icons.home, 0),
            _navIcon(Icons.search, 1),
            _navIcon(Icons.explore, 2),
            _navIcon(Icons.person_outline, 3),
          ],
        ),
      ),
    );
  }

  Widget _navIcon(IconData icon, int index) {
    return IconButton(
      onPressed: () => setState(() => selectedIndex = index),
      icon: Icon(
        icon,
        color: selectedIndex == index ? AppColors.yellow : AppColors.white,
        size: 32,
      ),
    );
  }
}