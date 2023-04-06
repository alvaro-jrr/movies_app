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
