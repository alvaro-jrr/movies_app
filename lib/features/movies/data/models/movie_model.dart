import 'package:movies_app/features/movies/domain/entities/movie.dart';

class MovieModel extends Movie {
  const MovieModel({
    required super.id,
    required super.originalTitle,
    required super.overview,
    required super.posterPath,
    required super.title,
    required super.voteAverage,
    super.releaseDate,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'],
      originalTitle: json['original_title'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      title: json['title'],
      voteAverage: (json['vote_average'] as num).toDouble(),
      releaseDate: json['release_date'] == null
          ? null
          : DateTime.parse(json['release_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'original_title': originalTitle,
      'overview': overview,
      'poster_path': posterPath,
      'title': title,
      'vote_average': voteAverage,
      'release_date':
          releaseDate == null ? null : releaseDate!.toIso8601String(),
    };
  }
}
