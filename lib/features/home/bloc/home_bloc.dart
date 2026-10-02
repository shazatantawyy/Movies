import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/features/home/data/movies_repository.dart';
import 'package:movies/models/movies_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final MoviesRepository _repository;

  HomeBloc(this._repository) : super(const HomeState()) {
    on<HomeStarted>(_onStarted);
  }

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final results = await Future.wait<List<Movies>>([
        _repository.getMovies(limit: 10),
        _repository.getMovies(genre: 'Action', limit: 10),
      ]);
      emit(state.copyWith(
        status: HomeStatus.success,
        featured: results[0],
        action: results[1],
      ));
    } on DioException catch (e) {
      emit(state.copyWith(
        status: HomeStatus.failure,
        errorMessage: e.message ?? 'Network error',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}