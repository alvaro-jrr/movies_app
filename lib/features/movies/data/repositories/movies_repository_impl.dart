import 'package:dartz/dartz.dart';

import 'package:movies_app/core/error/exceptions.dart';
import 'package:movies_app/core/error/failures.dart';
import 'package:movies_app/core/utils/network_info.dart';
import 'package:movies_app/features/movies/data/data_sources/movies_local_data_source.dart';
import 'package:movies_app/features/movies/data/data_sources/movies_remote_data_source.dart';
import 'package:movies_app/features/movies/data/models/movie_model.dart';
import 'package:movies_app/features/movies/domain/entities/genre.dart';
import 'package:movies_app/features/movies/domain/entities/movie.dart';
import 'package:movies_app/features/movies/domain/repositories/movies_repository.dart';

typedef _MoviesChooser = Future<List<MovieModel>> Function();

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
  Future<Either<Failure, List<Movie>>> getPopularMovies() async {
    return _getMovies(() => remoteDataSource.getPopularMovies());
  }

  @override
  Future<Either<Failure, List<Genre>>> getMovieGenres() async {
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
  Future<Either<Failure, List<Movie>>> getMoviesByGenre(int genreId) async {
    return _getMovies(() => remoteDataSource.getMoviesByGenre(genreId));
  }

  @override
  Future<Either<Failure, List<Movie>>> getMoviesByTitle(String title) async {
    return _getMovies(() => remoteDataSource.getMoviesByTitle(title));
  }

  Future<Either<Failure, List<Movie>>> _getMovies(
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
