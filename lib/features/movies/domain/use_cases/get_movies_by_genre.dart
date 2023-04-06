import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:movies_app/core/error/failures.dart';

import 'package:movies_app/core/use_cases/use_case.dart';
import 'package:movies_app/features/movies/domain/entities/movie.dart';
import 'package:movies_app/features/movies/domain/repositories/movies_repository.dart';

class GetMoviesByGenre implements UseCase<List<Movie>, Params> {
  final MoviesRepository repository;

  GetMoviesByGenre(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(Params params) {
    return repository.getMoviesByGenre(params.id);
  }
}

class Params extends Equatable {
  final int id;

  const Params({required this.id});

  @override
  List<Object> get props => [id];
}