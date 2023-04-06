import 'package:dartz/dartz.dart';

import 'package:movies_app/core/error/failures.dart';
import 'package:movies_app/core/use_cases/use_case.dart';
import 'package:movies_app/features/movies/domain/entities/genre.dart';
import 'package:movies_app/features/movies/domain/repositories/movies_repository.dart';

class GetMovieGenres implements UseCase<List<Genre>, NoParams> {
  final MoviesRepository repository;

  GetMovieGenres(this.repository);

  @override
  Future<Either<Failure, List<Genre>>> call(NoParams params) {
    return repository.getMovieGenres();
  }
}
