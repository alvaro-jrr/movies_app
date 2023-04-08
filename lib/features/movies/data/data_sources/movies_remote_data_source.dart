import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:movies_app/core/env/env.dart';
import 'package:movies_app/core/error/exceptions.dart';
import 'package:movies_app/features/movies/data/models/genre_response_model.dart';
import 'package:movies_app/features/movies/data/models/movie_response_model.dart';

abstract class MoviesRemoteDataSource {
  /// Calls the https://api.themoviedb.org/3/movie/popular endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<MovieResponseModel> getPopularMovies();

  /// Calls the https://api.themoviedb.org/3/genre/movie/list endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<GenreResponseModel> getMovieGenres();

  /// Calls the https://api.themoviedb.org/3/discover/movie endpoint with the [genreId].
  ///
  /// Throws a [ServerException] for all error codes.
  Future<MovieResponseModel> getMoviesByGenre(int genreId);

  /// Calls the https://api.themoviedb.org/3/search/movie endpoint with the [title].
  ///
  /// Throws a [ServerException] for all error codes.
  Future<MovieResponseModel> getMoviesByTitle(String title);
}

const tmdbApiKey = Env.tmdbApiKey;

class MoviesRemoteDataSourceImpl implements MoviesRemoteDataSource {
  final http.Client client;

  MoviesRemoteDataSourceImpl({
    required this.client,
  });

  @override
  Future<MovieResponseModel> getPopularMovies() async {
    final json = jsonDecode(await _getJsonDataFrom('/3/movie/popular'));
    return MovieResponseModel.fromJson(json);
  }

  @override
  Future<GenreResponseModel> getMovieGenres() async {
    final json = jsonDecode(await _getJsonDataFrom('/3/genre/movie/list'));
    return GenreResponseModel.fromJson(json);
  }

  @override
  Future<MovieResponseModel> getMoviesByGenre(int genreId) async {
    final json = jsonDecode(
      await _getJsonDataFrom('/3/discover/movie', {
        'with_genres': '$genreId',
      }),
    );

    return MovieResponseModel.fromJson(json);
  }

  @override
  Future<MovieResponseModel> getMoviesByTitle(String title) async {
    final json = jsonDecode(
      await _getJsonDataFrom('/3/search/movie', {
        'query': Uri.encodeComponent(title),
      }),
    );

    return MovieResponseModel.fromJson(json);
  }

  Future<String> _getJsonDataFrom(
    String endpoint, [
    Map<String, String> queryParameters = const {},
  ]) async {
    final response = await client.get(
      Uri.https('api.themoviedb.org', endpoint, {
        'api_key': tmdbApiKey,
        ...queryParameters,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) throw ServerException();

    return response.body;
  }
}
