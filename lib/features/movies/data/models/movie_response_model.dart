import 'package:movies_app/features/movies/data/models/movie_model.dart';
import 'package:movies_app/features/movies/domain/entities/movie_response.dart';

class MovieResponseModel extends MovieResponse {
  const MovieResponseModel({
    required super.page,
    required super.results,
    required super.totalPages,
  });

  factory MovieResponseModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> movies = json['results'];

    return MovieResponseModel(
      page: json['page'],
      results: movies.map((movie) => MovieModel.fromJson(movie)).toList(),
      totalPages: json['total_pages'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'results': results.map((result) => result.toJson()).toList(),
      'total_pages': totalPages,
    };
  }

  @override
  List<MovieModel> get results {
    return super.results.map((result) {
      return MovieModel(
        id: result.id,
        originalTitle: result.originalTitle,
        overview: result.overview,
        posterPath: result.posterPath,
        title: result.title,
        voteAverage: result.voteAverage,
        releaseDate: result.releaseDate,
      );
    }).toList();
  }
}
