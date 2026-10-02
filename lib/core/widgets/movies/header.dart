import 'package:flutter/material.dart';
import '../../../models/movie_details_model.dart';
import '../../app_colors/app_colors.dart';

class Header extends StatelessWidget {
  const Header({super.key, required this.movie, required this.onPlay});

  final MovieDetails movie;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 520,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            movie.backgroundImageOriginal ?? movie.mediumCoverImage ?? '',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: AppColors.grey),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.5, 1.0],
                colors: [Color(0x00121312), Color(0xFF121312)],
              ),
            ),
          ),
          Center(
            child: IconButton(
              onPressed: onPlay,
              iconSize: 80,
              icon: const Icon(Icons.play_circle_outline,
                  color: AppColors.yellow),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 8,
            child: Column(
              children: [
                Text(
                  movie.titleLong ?? '',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  '${movie.year ?? ''}',
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
