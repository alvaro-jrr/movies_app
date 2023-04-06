import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final int id;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String posterPath;
  final DateTime? releaseDate;
  final String title;
  final double voteAverage;

  const Movie({
    required this.id,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
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
      popularity,
      posterPath,
      title,
      voteAverage,
    ];
  }
}
