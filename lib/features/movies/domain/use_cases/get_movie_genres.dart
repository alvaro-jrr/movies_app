import 'package:dartz/dartz.dart';

import 'package:movies_app/core/error/failures.dart';
import 'package:movies_app/core/use_cases/use_case.dart';
import 'package:movies_app/features/movies/domain/entities/genre_response.dart';
import 'package:movies_app/features/movies/domain/repositories/movies_repository.dart';

class GetMovieGenres implements UseCase<GenreResponse, NoParams> {
  final MoviesRepository repository;

  GetMovieGenres(this.repository);

  @override
  Future<Either<Failure, GenreResponse>> call(NoParams params) {
    return repository.getMovieGenres();
  }
}
