import 'package:dartz/dartz.dart';

import 'package:movies_app/core/error/exceptions.dart';
import 'package:movies_app/core/error/failures.dart';
import 'package:movies_app/core/network/network_info.dart';
import 'package:movies_app/features/movies/data/data_sources/movies_local_data_source.dart';
import 'package:movies_app/features/movies/data/data_sources/movies_remote_data_source.dart';
import 'package:movies_app/features/movies/data/models/movie_response_model.dart';
import 'package:movies_app/features/movies/domain/entities/genre_response.dart';
import 'package:movies_app/features/movies/domain/entities/movie_response.dart';
import 'package:movies_app/features/movies/domain/repositories/movies_repository.dart';

typedef _MoviesChooser = Future<MovieResponseModel> Function();

class MoviesRepositoryImpl implements MoviesRepository {
  final MoviesLocalDataSource localDataSource;
  final MoviesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  MoviesRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, MovieResponse>> getPopularMovies() async {
    return _getMovies(() => remoteDataSource.getPopularMovies());
  }

  @override
  Future<Either<Failure, GenreResponse>> getMovieGenres() async {
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      try {
        return Right(await localDataSource.getLastGenres());
      } on CacheException {
        return Left(CacheFailure());
      }
    }

    try {
      final genres = await remoteDataSource.getMovieGenres();
      localDataSource.cacheGenres(genres);

      return Right(genres);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, MovieResponse>> getMoviesByGenre(int genreId) async {
    return _getMovies(() => remoteDataSource.getMoviesByGenre(genreId));
  }

  @override
  Future<Either<Failure, MovieResponse>> getMoviesByTitle(String title) async {
    return _getMovies(() => remoteDataSource.getMoviesByTitle(title));
  }

  Future<Either<Failure, MovieResponse>> _getMovies(
    _MoviesChooser getFilteredMovies,
  ) async {
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      try {
        return Right(await localDataSource.getLastMovies());
      } on CacheException {
        return Left(CacheFailure());
      }
    }

    try {
      final movies = await getFilteredMovies();
      localDataSource.cacheMovies(movies);

      return Right(movies);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
