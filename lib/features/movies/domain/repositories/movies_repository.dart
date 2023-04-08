import 'package:dartz/dartz.dart';

import 'package:movies_app/core/error/failures.dart';
import 'package:movies_app/features/movies/domain/entities/genre_response.dart';
import 'package:movies_app/features/movies/domain/entities/movie_response.dart';

abstract class MoviesRepository {
  Future<Either<Failure, MovieResponse>> getPopularMovies();

  Future<Either<Failure, GenreResponse>> getMovieGenres();

  Future<Either<Failure, MovieResponse>> getMoviesByGenre(int genreId);

  Future<Either<Failure, MovieResponse>> getMoviesByTitle(String title);
}
