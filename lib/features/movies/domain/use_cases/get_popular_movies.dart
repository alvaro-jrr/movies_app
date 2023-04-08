import 'package:dartz/dartz.dart';

import 'package:movies_app/core/error/failures.dart';
import 'package:movies_app/core/use_cases/use_case.dart';
import 'package:movies_app/features/movies/domain/entities/movie_response.dart';
import 'package:movies_app/features/movies/domain/repositories/movies_repository.dart';

class GetPopularMovies implements UseCase<MovieResponse, NoParams> {
  final MoviesRepository repository;

  GetPopularMovies(this.repository);

  @override
  Future<Either<Failure, MovieResponse>> call(NoParams params) {
    return repository.getPopularMovies();
  }
}
