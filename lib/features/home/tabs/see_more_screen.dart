import 'package:flutter/material.dart';
import 'package:movies/core/app_colors/app_colors.dart';
import 'package:movies/models/movies_model.dart';
import 'package:movies/features/home/movie_details_screen.dart';

class SeeMoreScreen extends StatelessWidget {
  final List<Movies> movies;

  const SeeMoreScreen({
    super.key,
    required this.movies,
  });

  void _openMovieDetails(BuildContext context, int? movieId) {
    if (movieId == null) return;

    Navigator.pushNamed(
      context,
      MovieDetailsScreen.routeName,
      arguments: movieId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        title: const Text('Action Movies'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 0.65,
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];

          return GestureDetector(
            onTap: () => _openMovieDetails(context, movie.id),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                movie.mediumCoverImage ?? '',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return const Icon(
                    Icons.broken_image,
                    color: AppColors.white,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}