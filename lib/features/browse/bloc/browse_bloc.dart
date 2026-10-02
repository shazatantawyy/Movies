import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/features/home/data/movies_repository.dart';
import 'package:movies/models/movies_model.dart';

sealed class BrowseEvent extends Equatable {
  const BrowseEvent();
  @override
  List<Object?> get props => [];
}

class BrowseStarted extends BrowseEvent {
  const BrowseStarted();
}

class BrowseGenreSelected extends BrowseEvent {
  final String genre;
  const BrowseGenreSelected(this.genre);
  @override
  List<Object?> get props => [genre];
}

enum BrowseStatus { initial, loading, success, failure }

class BrowseState extends Equatable {
  final BrowseStatus status;
  final List<Movies> allMovies;
  final List<String> genres;
  final String? selectedGenre;
  final String? errorMessage;

  const BrowseState({
    this.status = BrowseStatus.initial,
    this.allMovies = const [],
    this.genres = const [],
    this.selectedGenre,
    this.errorMessage,
  });

  List<Movies> get movies => allMovies
      .where((m) => m.genres?.contains(selectedGenre) ?? false)
      .toList();

  BrowseState copyWith({
    BrowseStatus? status,
    List<Movies>? allMovies,
    List<String>? genres,
    String? selectedGenre,
    String? errorMessage,
  }) {
    return BrowseState(
      status: status ?? this.status,
      allMovies: allMovies ?? this.allMovies,
      genres: genres ?? this.genres,
      selectedGenre: selectedGenre ?? this.selectedGenre,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, allMovies, genres, selectedGenre, errorMessage];
}

class BrowseBloc extends Bloc<BrowseEvent, BrowseState> {
  final MoviesRepository _repository;

  BrowseBloc(this._repository) : super(const BrowseState()) {
    on<BrowseStarted>(_onStarted);
    on<BrowseGenreSelected>(
          (event, emit) => emit(state.copyWith(selectedGenre: event.genre)),
    );
  }

  Future<void> _onStarted(
      BrowseStarted event,
      Emitter<BrowseState> emit,
      ) async {
    emit(state.copyWith(status: BrowseStatus.loading));
    try {
      final movies = await _repository.getMovies(limit: 50);

      final genreSet = <String>{};
      for (final movie in movies) {
        genreSet.addAll(movie.genres ?? const []);
      }
      final genres = genreSet.toList()..sort();

      emit(state.copyWith(
        status: BrowseStatus.success,
        allMovies: movies,
        genres: genres,
        selectedGenre: genres.isNotEmpty ? genres.first : null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BrowseStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
