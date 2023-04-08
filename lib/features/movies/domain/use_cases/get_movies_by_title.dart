import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:movies_app/core/error/failures.dart';
import 'package:movies_app/core/use_cases/use_case.dart';
import 'package:movies_app/features/movies/domain/entities/movie_response.dart';
import 'package:movies_app/features/movies/domain/repositories/movies_repository.dart';

class GetMoviesByTitle implements UseCase<MovieResponse, Params> {
  final MoviesRepository repository;

  GetMoviesByTitle(this.repository);

  @override
  Future<Either<Failure, MovieResponse>> call(Params params) {
    return repository.getMoviesByTitle(params.title);
  }
}

class Params extends Equatable {
  final String title;

  const Params({required this.title});

  @override
  List<Object> get props => [title];
}
