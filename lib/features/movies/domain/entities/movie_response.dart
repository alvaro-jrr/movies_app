import 'package:equatable/equatable.dart';
import 'package:movies_app/features/movies/domain/entities/movie.dart';

class MovieResponse extends Equatable {
  final int page;
  final List<Movie> results;
  final int totalPages;

  const MovieResponse({
    required this.page,
    required this.results,
    required this.totalPages,
  });

  @override
  List<Object> get props => [page, results, totalPages];
}
