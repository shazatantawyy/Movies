import 'package:flutter/material.dart';
import '../../../features/home/movie_details_screen.dart';
import '../../../models/movies_model.dart';
import 'movie_card.dart';

class SimilarMovies extends StatelessWidget {
  const SimilarMovies({super.key, required this.movies});

  final List<Movies> movies;

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox.shrink();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: movies.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.68,
      ),
      itemBuilder: (_, i) => MovieCard(
        movie: movies[i],
        onTap: () => Navigator.pushNamed(
          context,
          MovieDetailsScreen.routeName,
          arguments: movies[i].id,
        ),
      ),
    );
  }
}
