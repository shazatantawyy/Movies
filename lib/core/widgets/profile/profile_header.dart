import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../storage/user_storage.dart';
import '../../../features/login/login_screen.dart';
import '../../app_colors/app_colors.dart';
import 'app_button.dart';
import 'counter_item.dart';
import '../../../features/edit_profile/edit_profile_screen.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.name,
    required this.avatarPath,
    required this.watchListCount,
    required this.historyCount,
  });

  static const Color background = AppColors.grey;

  final String name;
  final String avatarPath;
  final int watchListCount;
  final int historyCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 134,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 58,
                        backgroundColor: AppColors.grey,
                        backgroundImage: AssetImage(avatarPath),
                        onBackgroundImageError: (error, _) =>
                            debugPrint('Avatar error: $error'),
                      ),
                      const SizedBox(height: 16),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          name,
                          maxLines: 1,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CounterItem(
                        count: watchListCount,
                        label: 'Wish List',
                      ),
                      CounterItem(
                        count: historyCount,
                        label: 'History',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: AppButton(
                    label: 'Edit Profile',
                    color: AppColors.yellow,
                    textColor: AppColors.black,
                    height: 56,
                    onTap: () => Navigator.pushNamed(
                      context,
                      EditProfileScreen.routeName,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppButton(
                    label: 'Exit',
                    icon: Icons.logout,
                    color: AppColors.red,
                    textColor: AppColors.white,
                    height: 56,
                    onTap: () async {
                      final navigator = Navigator.of(context);
                      await FirebaseAuth.instance.signOut();
                      await UserStorage.instance.clearAll();
                      navigator.pushNamedAndRemoveUntil(
                        LoginScreen.routeName,
                            (route) => false,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
