import 'package:flutter/material.dart';
import 'package:movies/core/widgets/profile/profile_header.dart';
import '../../app_colors/app_colors.dart';

class ProfileTabBar extends StatelessWidget {
  const ProfileTabBar({super.key});

  static const TextStyle _labelStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    return const Material(
      color: ProfileHeader.background,
      child: TabBar(
        indicatorColor: AppColors.yellow,
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: AppColors.white,
        unselectedLabelColor: AppColors.white,
        labelStyle: _labelStyle,
        unselectedLabelStyle: _labelStyle,
        tabs: [
          Tab(
            icon: Icon(
              Icons.format_list_bulleted,
              color: AppColors.yellow,
              size: 30,
            ),
            text: 'Watch List',
          ),
          Tab(
            icon: Icon(Icons.folder, color: AppColors.yellow, size: 30),
            text: 'History',
          ),
        ],
      ),
    );
  }
}