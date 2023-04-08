import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:movies_app/core/error/failures.dart';
import 'package:movies_app/core/use_cases/use_case.dart';
import 'package:movies_app/features/movies/domain/entities/movie_response.dart';
import 'package:movies_app/features/movies/domain/repositories/movies_repository.dart';

class GetMoviesByGenre
    implements UseCase<MovieResponse, GetMoviesByGenreParams> {
  final MoviesRepository repository;

  GetMoviesByGenre(this.repository);

  @override
  Future<Either<Failure, MovieResponse>> call(GetMoviesByGenreParams params) {
    return repository.getMoviesByGenre(params.id);
  }
}

class GetMoviesByGenreParams extends Equatable {
  final int id;

  const GetMoviesByGenreParams({required this.id});

  @override
  List<Object> get props => [id];
}
