import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/app_images/app_images.dart';
import 'package:movies/core/widgets/movies/movie_grid.dart';
import 'package:movies/features/home/data/movies_repository.dart';
import 'package:movies/features/home/search_screen/search_bloc.dart';
import '../../../core/app_colors/app_colors.dart';
import '../movie_details_screen.dart';

class SearchTab extends StatelessWidget {
  static const String routeName = "Search tab";
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(context.read<MoviesRepository>()),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  Timer? _debounce;

  void _onChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      context.read<SearchBloc>().add(SearchQueryChanged(text));
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: _onChanged,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.blue),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                switch (state.status) {
                  case SearchStatus.initial:
                    return const _EmptyState();
                  case SearchStatus.loading:
                    return const Center(child: CircularProgressIndicator());
                  case SearchStatus.failure:
                    return Center(
                      child: Text(
                        'Error: ${state.errorMessage}',
                        style: const TextStyle(color: AppColors.white),
                      ),
                    );
                  case SearchStatus.success:
                    if (state.movies.isEmpty) return const _EmptyState();
                    return MoviesGrid(
                      movies: state.movies,
                      onMovieTap: (movie) => Navigator.pushNamed(
                        context,
                        MovieDetailsScreen.routeName,
                        arguments: movie.id,
                      ),
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(child: Image.asset(AppImages.popcorn));
  }
}
