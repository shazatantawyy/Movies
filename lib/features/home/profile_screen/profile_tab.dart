import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/app_avatar/app_avatar.dart';
import 'package:movies/core/storage/user_storage.dart';
import 'package:movies/features/home/profile_screen/profile_cubit.dart';
import '../../../core/widgets/profile/movie_tab.dart';
import '../../../core/widgets/profile/profile_header.dart';
import '../../../core/widgets/profile/profile_tab_bar.dart';

class ProfileTab extends StatelessWidget {
  static const String routeName = "profile tab";
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(UserStorage.instance),
      child: DefaultTabController(
        length: 2,
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return Column(
              children: [
                ProfileHeader(
                  name: state.name,
                  avatarPath: AppAvatar.avatar[state.avatarIndex],
                  watchListCount: state.watchList.length,
                  historyCount: state.history.length,
                ),
                const ProfileTabBar(),
                Expanded(
                  child: TabBarView(
                    children: [
                      MoviesTab(movies: state.watchList),
                      MoviesTab(movies: state.history),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
