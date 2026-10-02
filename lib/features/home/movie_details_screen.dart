import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/storage/user_storage.dart';
import 'package:movies/core/widgets/home_widgets/error_retry_view.dart';
import 'package:movies/features/home/bloc/details_bloc.dart';
import 'package:movies/features/home/data/movies_repository.dart';
import 'package:movies/models/movie_details_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/app_colors/app_colors.dart';
import '../../core/widgets/movies/cast_tile.dart';
import '../../core/widgets/movies/circle_icon_button.dart';
import '../../core/widgets/movies/genre_wrap.dart';
import '../../core/widgets/movies/header.dart';
import '../../core/widgets/movies/screenshots.dart';
import '../../core/widgets/movies/section_title.dart';
import '../../core/widgets/movies/similar_movies.dart';
import '../../core/widgets/movies/stats_row.dart';
import '../../core/widgets/movies/watch_button.dart';

class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen({super.key});

  static const String routeName = 'MovieDetails';

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;

    return BlocProvider(
      create: (context) => DetailsBloc(
        context.read<MoviesRepository>(),
        UserStorage.instance,
      )..add(DetailsStarted(id)),
      child: const _DetailsView(),
    );
  }
}

class _DetailsView extends StatelessWidget {
  const _DetailsView();

  Future<void> _openTrailer(MovieDetails movie) async {
    final code = movie.ytTrailerCode;
    if (code == null || code.isEmpty) return;

    await launchUrl(
      Uri.parse('https://www.youtube.com/watch?v=$code'),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DetailsBloc, DetailsState>(
        builder: (context, state) {
          final movie = state.movie;

          if (state.status == DetailsStatus.failure) {
            return Stack(
              children: [
                ErrorRetryView(
                  message: state.errorMessage ?? 'Movie not found',
                  onRetry: () {
                    final id =
                    ModalRoute.of(context)!.settings.arguments as int;
                    context.read<DetailsBloc>().add(DetailsStarted(id));
                  },
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: CircleIconButton(
                      icon: Icons.arrow_back_ios_new,
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            );
          }

          if (state.status != DetailsStatus.success || movie == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Header(movie: movie, onPlay: () => _openTrailer(movie)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WatchButton(onTap: () => _openTrailer(movie)),
                          const SizedBox(height: 12),
                          StatsRow(movie: movie),
                          if (movie.screenshots.isNotEmpty) ...[
                            const SectionTitle('Screen Shots'),
                            Screenshots(urls: movie.screenshots),
                          ],
                          if (state.similar.isNotEmpty) ...[
                            const SectionTitle('Similar'),
                            SimilarMovies(movies: state.similar),
                          ],
                          if (movie.descriptionFull?.isNotEmpty ?? false) ...[
                            const SectionTitle('Summary'),
                            Text(
                              movie.descriptionFull!,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                          if (movie.cast.isNotEmpty) ...[
                            const SectionTitle('Cast'),
                            ...movie.cast.map((c) => CastTile(cast: c)),
                          ],
                          if (movie.genres.isNotEmpty) ...[
                            const SectionTitle('Genres'),
                            GenresWrap(genres: movie.genres),
                          ],
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleIconButton(
                          icon: Icons.arrow_back_ios_new,
                          onTap: () => Navigator.pop(context),
                        ),
                        CircleIconButton(
                          icon: state.isSaved
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: state.isSaved
                              ? AppColors.yellow
                              : AppColors.white,
                          onTap: () => context
                              .read<DetailsBloc>()
                              .add(const DetailsWatchListToggled()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
