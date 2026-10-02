import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/widgets/home_widgets/home_error_view.dart';
import 'package:movies/core/app_colors/app_colors.dart';
import 'package:movies/core/app_images/app_images.dart';
import 'package:movies/features/home/bloc/home_bloc.dart';
import 'package:movies/features/home/data/movies_repository.dart';
import 'package:movies/features/home/movie_details_screen.dart';
import 'package:movies/features/home/tabs/see_more_screen.dart';
import 'package:movies/models/movies_model.dart';

class HomeTab extends StatelessWidget {
  static const String routeName = "home tab";
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      HomeBloc(context.read<MoviesRepository>())..add(const HomeStarted()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(AppImages.bg6, fit: BoxFit.cover),
        ),
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.6, 0.8],
                colors: [
                  Color(0x00121312),
                  Color(0xCC121312),
                  Color(0xCC121312),
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              switch (state.status) {
                case HomeStatus.initial:
                case HomeStatus.loading:
                  return const Center(child: CircularProgressIndicator());
                case HomeStatus.failure:
                  return HomeErrorView(message: state.errorMessage ?? 'Error');
                case HomeStatus.success:
                  return _HomeContent(state: state);
              }
            },
          ),
        ),
      ],
    );
  }
}


void _openMovieDetails(BuildContext context, int? movieId) {
  if (movieId == null) return;
  Navigator.pushNamed(
    context,
    MovieDetailsScreen.routeName,
    arguments: movieId,
  );
}

class _HomeContent extends StatelessWidget {
  final HomeState state;
  const _HomeContent({required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: Image.asset(
                AppImages.title,
                width: (MediaQuery.sizeOf(context).width * 0.7).clamp(150.0, 320.0),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 5),
          _FeaturedCarousel(movies: state.featured),
          const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Image.asset(AppImages.watch, fit: BoxFit.contain),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Action',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SeeMoreScreen(
                          movies: state.action,
                        ),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Text(
                      'See More →',
                      style: TextStyle(
                        color: AppColors.yellow,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _MoviesRow(movies: state.action),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _FeaturedCarousel extends StatefulWidget {
  final List<Movies> movies;
  const _FeaturedCarousel({required this.movies});

  @override
  State<_FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<_FeaturedCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.55);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (MediaQuery.sizeOf(context).height * 0.32).clamp(200.0, 340.0),
      child: PageView.builder(
        controller: _controller,
        itemCount: widget.movies.length,
        itemBuilder: (context, index) {
          final movie = widget.movies[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: () => _openMovieDetails(context, movie.id),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.network(
                      movie.largeCoverImage ?? '',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, color: AppColors.white),
                    ),
                  ),
                  Positioned(
                    top: 15,
                    left: 15,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '${movie.rating ?? 0}',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.star,
                            color: AppColors.yellow,
                            size: 22,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MoviesRow extends StatelessWidget {
  final List<Movies> movies;
  const _MoviesRow({required this.movies});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (MediaQuery.sizeOf(context).height * 0.3).clamp(200.0, 320.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return GestureDetector(
            onTap: () => _openMovieDetails(context, movie.id),
            child: Container(
              width: (MediaQuery.sizeOf(context).width * 0.42).clamp(130.0, 220.0),
              margin: const EdgeInsets.only(right: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.mediumCoverImage ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.broken_image, color: AppColors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}