import 'package:flutter/material.dart';
import '../../../models/movie_details_model.dart';
import '../../app_colors/app_colors.dart';

class CastTile extends StatelessWidget {
  const CastTile({super.key, required this.cast});

  final Cast cast;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              cast.urlSmallImage ?? '',
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 70,
                height: 70,
                color: Colors.black26,
                child: const Icon(Icons.person, color: AppColors.white),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name : ${cast.name ?? ''}',
                  style: const TextStyle(color: AppColors.white, fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  'Character : ${cast.characterName ?? ''}',
                  style: const TextStyle(color: AppColors.white, fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
