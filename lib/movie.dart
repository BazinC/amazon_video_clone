import 'package:demo_app/constants.dart';

class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
  });

  String get imagePath => '$imageUrlPrefix/$posterPath';

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'],
    );
  }
}
