import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final int id;
  final String originalTitle;
  final String overview;
  final String posterPath;
  final DateTime? releaseDate;
  final String title;
  final double voteAverage;

  const Movie({
    required this.id,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    this.releaseDate,
    required this.title,
    required this.voteAverage,
  });

  @override
  List<Object> get props {
    return [
      id,
      originalTitle,
      overview,
      posterPath,
      title,
      voteAverage,
    ];
  }

  String get fullPosterPath {
    return "https://image.tmdb.org/t/p/w500/$posterPath";
  }
}
