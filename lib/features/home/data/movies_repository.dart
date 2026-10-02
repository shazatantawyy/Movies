import 'package:movies/core/api/api_manager.dart';
import 'package:movies/models/movie_details_model.dart';
import 'package:movies/models/movies_model.dart';

class MoviesRepository {
  final ApiManager _api;
  MoviesRepository(this._api);

  Future<List<Movies>> getMovies({
    String? genre,
    String? query,
    int limit = 10,
    int page = 1,
  }) async {
    final model = await _api.getMovies(
      genre: genre,
      query: query,
      limit: limit,
      page: page,
    );
    return model.data?.movies ?? [];
  }

  Future<MovieDetails?> getMovieDetails(int id) async =>
      (await _api.getMovieDetails(id)).movie;

  Future<List<Movies>> getSuggestions(int id) async =>
      (await _api.getSuggestions(id)).data?.movies ?? [];
}
