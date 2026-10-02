import 'package:flutter/material.dart';
import 'package:movies/core/widgets/movies/stat_box.dart';

import '../../../models/movie_details_model.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({super.key, required this.movie});

  final MovieDetails movie;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child:
          StatBox(icon: Icons.favorite, value: '${movie.likeCount ?? 0}'),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StatBox(
              icon: Icons.access_time_filled, value: '${movie.runtime ?? 0}'),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StatBox(icon: Icons.star, value: '${movie.rating ?? 0}'),
        ),
      ],
    );
  }
}
