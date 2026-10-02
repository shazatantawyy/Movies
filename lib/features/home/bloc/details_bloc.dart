import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/storage/user_storage.dart';
import 'package:movies/features/home/data/movies_repository.dart';
import 'package:movies/models/movie_details_model.dart';
import 'package:movies/models/movies_model.dart';

extension MovieDetailsX on MovieDetails {
  Movies toMovies() => Movies(
    id: id,
    mediumCoverImage: mediumCoverImage,
    rating: rating,
  );
}

sealed class DetailsEvent extends Equatable {
  const DetailsEvent();
  @override
  List<Object?> get props => [];
}

class DetailsStarted extends DetailsEvent {
  final int movieId;
  const DetailsStarted(this.movieId);
  @override
  List<Object?> get props => [movieId];
}

class DetailsWatchListToggled extends DetailsEvent {
  const DetailsWatchListToggled();
}

enum DetailsStatus { initial, loading, success, failure }

class DetailsState extends Equatable {
  final DetailsStatus status;
  final MovieDetails? movie;
  final List<Movies> similar;
  final bool isSaved;
  final String? errorMessage;

  const DetailsState({
    this.status = DetailsStatus.initial,
    this.movie,
    this.similar = const [],
    this.isSaved = false,
    this.errorMessage,
  });

  DetailsState copyWith({
    DetailsStatus? status,
    MovieDetails? movie,
    List<Movies>? similar,
    bool? isSaved,
    String? errorMessage,
  }) {
    return DetailsState(
      status: status ?? this.status,
      movie: movie ?? this.movie,
      similar: similar ?? this.similar,
      isSaved: isSaved ?? this.isSaved,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, movie, similar, isSaved, errorMessage];
}

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final MoviesRepository _repository;
  final UserStorage _storage;
  int? _movieId;

  DetailsBloc(this._repository, this._storage) : super(const DetailsState()) {
    on<DetailsStarted>(_onStarted);
    on<DetailsWatchListToggled>(_onToggled);
  }

  Future<void> _onStarted(
      DetailsStarted event,
      Emitter<DetailsState> emit,
      ) async {
    _movieId = event.movieId;
    emit(state.copyWith(status: DetailsStatus.loading));
    try {
      final detailsFuture = _repository.getMovieDetails(event.movieId);
      final similarFuture = _repository
          .getSuggestions(event.movieId)
          .catchError((_) => <Movies>[]);

      final movie = await detailsFuture;
      final similar = await similarFuture;

      if (movie == null) {
        emit(state.copyWith(
          status: DetailsStatus.failure,
          errorMessage: 'Movie not found',
        ));
        return;
      }

      // Opening a movie = it goes to the History list.
      await _storage.addToHistory(movie.toMovies());

      emit(state.copyWith(
        status: DetailsStatus.success,
        movie: movie,
        similar: similar,
        isSaved: _storage.isInWatchList(movie.id),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DetailsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onToggled(
      DetailsWatchListToggled event,
      Emitter<DetailsState> emit,
      ) async {
    final movie = state.movie;
    if (movie == null) return;
    await _storage.toggleWatchList(movie.toMovies());
    emit(state.copyWith(isSaved: _storage.isInWatchList(_movieId)));
  }
}
