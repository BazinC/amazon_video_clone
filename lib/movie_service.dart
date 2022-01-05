import 'package:demo_app/constants.dart';
import 'package:demo_app/movie.dart';
import 'package:dio/dio.dart';

const queryParam = {'api_key': apiKey};
const apiBaseUrl = 'https://api.themoviedb.org';

class MovieService {
  static Future<List<Movie>> getTopRatedMovies() async {
    try {
      var response = await Dio()
          .get('$apiBaseUrl/3/movie/top_rated', queryParameters: queryParam);
      final movies = (response.data['results'] as List)
          .map((e) => Movie.fromJson(e))
          .toList();
      return movies;
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<List<Movie>> getTrendingMovies() async {
    try {
      var response = await Dio().get('$apiBaseUrl/3/trending/movie/week',
          queryParameters: queryParam);
      final movies = (response.data['results'] as List)
          .map((e) => Movie.fromJson(e))
          .toList();
      return movies;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
