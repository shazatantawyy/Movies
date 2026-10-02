import 'package:flutter/material.dart';

import '../../app_colors/app_colors.dart';

class GenresWrap extends StatelessWidget {
  const GenresWrap({super.key, required this.genres});

  final List<String> genres;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: genres
          .map(
            (genre) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.grey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            genre,
            style: const TextStyle(color: AppColors.white, fontSize: 16),
          ),
        ),
      )
          .toList(),
    );
  }
}
