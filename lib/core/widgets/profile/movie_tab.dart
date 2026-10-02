import 'package:flutter/material.dart';
import '../../../features/home/movie_details_screen.dart';
import '../../../models/movies_model.dart';
import '../../app_images/app_images.dart';
import '../movies/movie_grid.dart';

class MoviesTab extends StatelessWidget {
  const MoviesTab({super.key, required this.movies});

  final List<Movies> movies;

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return Center(
          child: Image.asset(
            AppImages.popcorn,
            width: 120,
          ));
    }

    return MoviesGrid(
      movies: movies,
      onMovieTap: (movie) => Navigator.pushNamed(
        context,
        MovieDetailsScreen.routeName,
        arguments: movie.id,
      ),
    );
  }
}
