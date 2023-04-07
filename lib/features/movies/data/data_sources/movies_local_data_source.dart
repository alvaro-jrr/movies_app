import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:movies_app/core/error/exceptions.dart';
import 'package:movies_app/features/movies/data/models/genre_model.dart';
import 'package:movies_app/features/movies/data/models/movie_model.dart';

abstract class MoviesLocalDataSource {
  /// Gets the cached [MovieModel] list which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws a [CacheException] if no cached data is present.
  Future<List<MovieModel>> getLastMovies();

  /// Gets the cached [GenreModel] list which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws a [CacheException] if no cached data is present.
  Future<List<GenreModel>> getLastGenres();

  /// Stores the movies in cache.
  Future<void> cacheMovies(List<MovieModel> moviesToCache);

  /// Stores the genres in cache.
  Future<void> cacheGenres(List<GenreModel> genresToCache);
}

const cachedMoviesKey = 'MOVIES';
const cachedGenresKey = 'GENRES';

class MoviesLocalDataSourceImpl implements MoviesLocalDataSource {
  final SharedPreferences sharedPreferences;

  MoviesLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<MovieModel>> getLastMovies() {
    final jsonList = _getCachedJsonList(cachedMoviesKey);

    // Turn each json to a MovieModel list.
    final movies = jsonList.map((json) => MovieModel.fromJson(json)).toList();
    return Future.value(movies);
  }

  @override
  Future<List<GenreModel>> getLastGenres() {
    final jsonList = _getCachedJsonList(cachedGenresKey);

    // Turn each json to a GenreModel list.
    final genres = jsonList.map((json) => GenreModel.fromJson(json)).toList();
    return Future.value(genres);
  }

  @override
  Future<void> cacheMovies(List<MovieModel> moviesToCache) {
    return _eitherCacheMoviesOrGenres(Left(moviesToCache));
  }

  @override
  Future<void> cacheGenres(List<GenreModel> genresToCache) {
    return _eitherCacheMoviesOrGenres(Right(genresToCache));
  }

  List<dynamic> _getCachedJsonList(String cacheKey) {
    // Get the json.
    final jsonString = sharedPreferences.getString(cacheKey);

    if (jsonString == null) throw CacheException();

    return jsonDecode(jsonString);
  }

  Future<void> _eitherCacheMoviesOrGenres(
    Either<List<MovieModel>, List<GenreModel>> modelEither,
  ) async {
    late String cacheKey;

    final jsonString = modelEither.fold(
      (movies) {
        cacheKey = cachedMoviesKey;
        return jsonEncode(movies.map((movie) => movie.toJson()).toList());
      },
      (genres) {
        cacheKey = cachedGenresKey;
        return jsonEncode(genres.map((genre) => genre.toJson()).toList());
      },
    );

    await sharedPreferences.setString(cacheKey, jsonString);
  }
}
