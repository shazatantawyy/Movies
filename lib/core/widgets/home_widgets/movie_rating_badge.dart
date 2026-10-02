import 'package:flutter/material.dart';
import 'package:movies/core/app_colors/app_colors.dart';

class MovieRatingBadge extends StatelessWidget {
  final double? rating;
  const MovieRatingBadge({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${rating ?? 0}',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(width: 5),
          const Icon(Icons.star, color: AppColors.yellow, size: 22),
        ],
      ),
    );
  }
}