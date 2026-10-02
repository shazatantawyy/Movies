import 'package:flutter/material.dart';
import '../../app_colors/app_colors.dart';

class Screenshots extends StatelessWidget {
  const Screenshots({super.key, required this.urls});

  final List<String> urls;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: urls
          .map(
            (url) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              url,
              width: double.infinity,
              height: 160,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(height: 160, color: AppColors.grey),
            ),
          ),
        ),
      )
          .toList(),
    );
  }
}
