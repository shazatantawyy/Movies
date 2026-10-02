import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/widgets/home_widgets/error_retry_view.dart';
import 'package:movies/core/widgets/movies/movie_grid.dart';
import 'package:movies/features/browse/bloc/browse_bloc.dart';
import 'package:movies/features/home/data/movies_repository.dart';
import 'package:movies/features/home/movie_details_screen.dart';
import '../../../core/widgets/movies/genre_chip.dart';

class ExploreTab extends StatelessWidget {
  static const String routeName = "explore screen";
  const ExploreTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      BrowseBloc(context.read<MoviesRepository>())..add(const BrowseStarted()),
      child: const _BrowseView(),
    );
  }
}

class _BrowseView extends StatelessWidget {
  const _BrowseView();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<BrowseBloc, BrowseState>(
        builder: (context, state) {
          switch (state.status) {
            case BrowseStatus.initial:
            case BrowseStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case BrowseStatus.failure:
              return ErrorRetryView(
                message: state.errorMessage ?? 'Error',
                onRetry: () =>
                    context.read<BrowseBloc>().add(const BrowseStarted()),
              );
            case BrowseStatus.success:
              return Column(
                children: [
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 44,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.genres.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (_, index) {
                        final genre = state.genres[index];
                        return GenreChip(
                          label: genre,
                          isSelected: genre == state.selectedGenre,
                          onTap: () => context
                              .read<BrowseBloc>()
                              .add(BrowseGenreSelected(genre)),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: MoviesGrid(
                      movies: state.movies,
                      onMovieTap: (movie) => Navigator.pushNamed(
                        context,
                        MovieDetailsScreen.routeName,
                        arguments: movie.id,
                      ),
                    ),
                  ),
                ],
              );
          }
        },
      ),
    );
  }
}
