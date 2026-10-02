import 'package:flutter/material.dart';

import '../../../models/movies_model.dart';
import 'movie_card.dart';

class MoviesGrid extends StatelessWidget {
  const MoviesGrid({super.key, required this.movies, this.onMovieTap});

  final List<Movies> movies;
  final void Function(Movies movie)? onMovieTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
      itemCount: movies.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.68,
      ),
      itemBuilder: (_, i) => MovieCard(
        movie: movies[i],
        onTap: onMovieTap == null ? null : () => onMovieTap!(movies[i]),
      ),
    );
  }
}
