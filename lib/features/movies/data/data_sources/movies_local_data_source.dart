import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:movies_app/features/movies/data/models/genre_response_model.dart';
import 'package:movies_app/features/movies/data/models/movie_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:movies_app/core/error/exceptions.dart';
import 'package:movies_app/features/movies/data/models/genre_model.dart';
import 'package:movies_app/features/movies/data/models/movie_model.dart';

abstract class MoviesLocalDataSource {
  /// Gets the cached [MovieModel] list which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws a [CacheException] if no cached data is present.
  Future<MovieResponseModel> getLastMovies();

  /// Gets the cached [GenreModel] list which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws a [CacheException] if no cached data is present.
  Future<GenreResponseModel> getLastGenres();

  /// Stores the movies in cache.
  Future<void> cacheMovies(MovieResponseModel moviesToCache);

  /// Stores the genres in cache.
  Future<void> cacheGenres(GenreResponseModel genresToCache);
}

const cachedMoviesKey = 'MOVIES';
const cachedGenresKey = 'GENRES';

class MoviesLocalDataSourceImpl implements MoviesLocalDataSource {
  final SharedPreferences sharedPreferences;

  MoviesLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<MovieResponseModel> getLastMovies() {
    final json = _getCachedJson(cachedMoviesKey);

    return Future.value(MovieResponseModel.fromJson(json));
  }

  @override
  Future<GenreResponseModel> getLastGenres() {
    final json = _getCachedJson(cachedGenresKey);

    return Future.value(GenreResponseModel.fromJson(json));
  }

  @override
  Future<void> cacheMovies(MovieResponseModel moviesToCache) {
    return _eitherCacheMoviesOrGenres(Left(moviesToCache));
  }

  @override
  Future<void> cacheGenres(GenreResponseModel genresToCache) {
    return _eitherCacheMoviesOrGenres(Right(genresToCache));
  }

  Map<String, dynamic> _getCachedJson(String cacheKey) {
    // Get the json.
    final jsonString = sharedPreferences.getString(cacheKey);

    if (jsonString == null) throw CacheException();

    return jsonDecode(jsonString);
  }

  Future<void> _eitherCacheMoviesOrGenres(
    Either<MovieResponseModel, GenreResponseModel> modelEither,
  ) async {
    late String cacheKey;

    final jsonString = modelEither.fold(
      (movies) {
        cacheKey = cachedMoviesKey;
        return jsonEncode(movies.toJson());
      },
      (genres) {
        cacheKey = cachedGenresKey;
        return jsonEncode(genres.toJson());
      },
    );

    await sharedPreferences.setString(cacheKey, jsonString);
  }
}
