import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/features/home/data/movies_repository.dart';
import 'package:movies/models/movies_model.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();
  @override
  List<Object?> get props => [];
}

class SearchQueryChanged extends SearchEvent {
  final String query;
  const SearchQueryChanged(this.query);
  @override
  List<Object?> get props => [query];
}

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  final SearchStatus status;
  final List<Movies> movies;
  final String? errorMessage;

  const SearchState({
    this.status = SearchStatus.initial,
    this.movies = const [],
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, movies, errorMessage];
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final MoviesRepository _repository;
  String _latestQuery = '';

  SearchBloc(this._repository) : super(const SearchState()) {
    on<SearchQueryChanged>(_onQueryChanged);
  }

  Future<void> _onQueryChanged(
      SearchQueryChanged event,
      Emitter<SearchState> emit,
      ) async {
    final query = event.query.trim();
    _latestQuery = query;

    if (query.isEmpty) {
      emit(const SearchState());
      return;
    }

    emit(const SearchState(status: SearchStatus.loading));
    try {
      final movies = await _repository.getMovies(query: query, limit: 20);
      if (query != _latestQuery) return; // a newer search replaced this one
      emit(SearchState(status: SearchStatus.success, movies: movies));
    } catch (e) {
      if (query != _latestQuery) return;
      emit(SearchState(status: SearchStatus.failure, errorMessage: e.toString()));
    }
  }
}
