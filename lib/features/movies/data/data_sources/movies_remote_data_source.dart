import 'package:movies_app/core/error/exceptions.dart';
import 'package:movies_app/features/movies/data/models/genre_model.dart';
import 'package:movies_app/features/movies/data/models/movie_model.dart';

abstract class MoviesRemoteDataSource {
  /// Calls the https://api.themoviedb.org/3/movie/popular endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<MovieModel>> getPopularMovies();

  /// Calls the https://api.themoviedb.org/3/genre/movie/list endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<GenreModel>> getMovieGenres();

  /// Calls the https://api.themoviedb.org/3/discover/movie endpoint with the [genreId].
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<MovieModel>> getMoviesByGenre(int genreId);

  /// Calls the https://api.themoviedb.org/3/search/movie endpoint with the [title].
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<MovieModel>> getMoviesByTitle(String title);
}
