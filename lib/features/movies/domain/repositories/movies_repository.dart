import 'package:dartz/dartz.dart';

import 'package:movies_app/core/error/failures.dart';
import 'package:movies_app/features/movies/domain/entities/genre.dart';
import 'package:movies_app/features/movies/domain/entities/movie.dart';

abstract class MoviesRepository {
  Future<Either<Failure, List<Movie>>> getPopularMovies();

  Future<Either<Failure, List<Genre>>> getMovieGenres();

  Future<Either<Failure, List<Movie>>> getMoviesByGenre(int genreId);

  Future<Either<Failure, List<Movie>>> getMoviesByTitle(String title);
}
