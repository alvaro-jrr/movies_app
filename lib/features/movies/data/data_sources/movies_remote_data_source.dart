import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:movies_app/core/env/env.dart';
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

const tmdbApiKey = Env.tmdbApiKey;

class MoviesRemoteDataSourceImpl implements MoviesRemoteDataSource {
  final http.Client client;

  MoviesRemoteDataSourceImpl({
    required this.client,
  });

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    final Map<String, dynamic> json =
        jsonDecode(await _getJsonDataFrom('/3/movie/popular'));
    final List<dynamic> results = json['results'];
    return results.map((json) => MovieModel.fromJson(json)).toList();
  }

  @override
  Future<List<GenreModel>> getMovieGenres() async {
    final List<dynamic> jsonList =
        jsonDecode(await _getJsonDataFrom('/3/genre/movie/list'))['genres'];

    return jsonList.map((json) => GenreModel.fromJson(json)).toList();
  }

  @override
  Future<List<MovieModel>> getMoviesByGenre(int genreId) async {
    final List<dynamic> jsonList = jsonDecode(
      await _getJsonDataFrom('/3/discover/movie', {
        'with_genres': '$genreId',
      }),
    )['results'];

    return jsonList.map((json) => MovieModel.fromJson(json)).toList();
  }

  @override
  Future<List<MovieModel>> getMoviesByTitle(String title) async {
    final List<dynamic> jsonList = jsonDecode(
      await _getJsonDataFrom('/3/search/movie', {
        'query': Uri.encodeComponent(title),
      }),
    )['results'];

    return jsonList.map((json) => MovieModel.fromJson(json)).toList();
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
