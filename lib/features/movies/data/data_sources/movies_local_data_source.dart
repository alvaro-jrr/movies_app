import 'dart:convert';

import 'package:movies_app/core/error/exceptions.dart';
import 'package:movies_app/features/movies/data/models/genre_model.dart';
import 'package:movies_app/features/movies/data/models/movie_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class MoviesLocalDataSourceImpl implements MoviesLocalDataSource {
  final SharedPreferences sharedPreferences;

  MoviesLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<MovieModel>> getLastMovies() {
    // Get the movies list of json strings.
    final jsonStringList = sharedPreferences.getStringList(cachedMoviesKey);

    if (jsonStringList == null) throw CacheException();

    // Turn each json to a MovieModel list.
    final movies = jsonStringList.map((movieJson) {
      return MovieModel.fromJson(jsonDecode(movieJson));
    }).toList();

    return Future.value(movies);
  }

  @override
  Future<List<GenreModel>> getLastGenres() {
    // TODO: implement getLastGenres
    throw UnimplementedError();
  }

  @override
  Future<void> cacheMovies(List<MovieModel> moviesToCache) async {
    final jsonStringList = moviesToCache.map((movie) {
      return jsonEncode(movie.toJson());
    }).toList();

    await sharedPreferences.setStringList(cachedMoviesKey, jsonStringList);
  }

  @override
  Future<void> cacheGenres(List<GenreModel> genresToCache) {
    // TODO: implement cacheGenres
    throw UnimplementedError();
  }
}
