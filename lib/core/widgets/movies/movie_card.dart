import 'package:flutter/material.dart';
import 'package:movies/models/movies_model.dart';
import '../../app_colors/app_colors.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({super.key, required this.movie, this.onTap});

  final Movies movie;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              movie.mediumCoverImage ?? '',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.grey,
                child: const Center(
                  child: Icon(Icons.broken_image, color: AppColors.white),
                ),
              ),
            ),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text(
                    '${movie.rating ?? 0}',
                    style: const TextStyle(color: AppColors.white),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.star, color: AppColors.yellow, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
