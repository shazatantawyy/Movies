import 'package:dio/dio.dart';
import '../../models/movie_details_model.dart';
import '../../models/movies_model.dart';

class ApiManager {
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ),
  );

  static const String baseUrl = 'https://movies-api.accel.li/api/v2';

  Future<MoviesModel> getMovies({
    String? genre,
    String? query,
    int limit = 10,
    int page = 1,
  }) async {
    final response = await dio.get(
      '$baseUrl/list_movies.json',
      queryParameters: {
        'limit': limit,
        'page': page,
        'sort_by': 'date_added',
        'order_by': 'desc',
        if (genre != null) 'genre': genre,
        if (query != null && query.isNotEmpty) 'query_term': query,
      },
    );

    return MoviesModel.fromJson(response.data);
  }

  Future<MovieDetailsModel> getMovieDetails(int id) async {
    final response = await dio.get(
      '$baseUrl/movie_details.json',
      queryParameters: {
        'movie_id': id,
        'with_images': true,
        'with_cast': true,
      },
    );

    return MovieDetailsModel.fromJson(response.data);
  }

  Future<MoviesModel> getSuggestions(int id) async {
    final response = await dio.get(
      '$baseUrl/movie_suggestions.json',
      queryParameters: {'movie_id': id},
    );

    return MoviesModel.fromJson(response.data);
  }
}