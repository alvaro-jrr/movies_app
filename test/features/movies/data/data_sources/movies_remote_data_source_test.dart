import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import 'package:movies_app/core/error/exceptions.dart';
import 'package:movies_app/features/movies/data/data_sources/movies_remote_data_source.dart';
import 'package:movies_app/features/movies/data/models/genre_response_model.dart';
import 'package:movies_app/features/movies/data/models/movie_response_model.dart';

import '../../../../fixtures/fixture_reader.dart';
@GenerateNiceMocks([MockSpec<http.Client>()])
import 'movies_remote_data_source_test.mocks.dart';

void main() {
  late MockClient mockClient;
  late MoviesRemoteDataSourceImpl dataSourceImpl;

  setUp(() {
    mockClient = MockClient();
    dataSourceImpl = MoviesRemoteDataSourceImpl(client: mockClient);
  });

  final tMovieJson = jsonDecode(fixture('movies_response.json'));
  final tMovieResponseModel = MovieResponseModel.fromJson(tMovieJson);

  group('getPopularMovies', () {
    test(
      '''should perform a GET request on a URL with the API Key 
      in query parameters and with the application/json header''',
      () async {
        // arrange
        when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (_) async => http.Response(fixture('movies_response.json'), 200));

        // act
        await dataSourceImpl.getPopularMovies();

        // assert
        verify(
          mockClient.get(
            Uri.https('api.themoviedb.org', '3/movie/popular', {
              'api_key': tmdbApiKey,
            }),
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        );
      },
    );

    test(
      'should return a MovieResponse when the status code is 200 (success)',
      () async {
        // arrange
        when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (_) async => http.Response(fixture('movies_response.json'), 200));

        // act
        final result = await dataSourceImpl.getPopularMovies();

        // assert
        expect(result, tMovieResponseModel);
      },
    );

    test(
      'should throw a ServerException when the status code is 404 or other',
      () async {
        // arrange
        when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (_) async => http.Response('Something went wrong', 404));

        // act
        final call = dataSourceImpl.getPopularMovies;

        // assert
        expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });

  group('getMovieGenres', () {
    final Map<String, dynamic> tGenreJson =
        jsonDecode(fixture('genres_cached.json'));
    final tGenreResponseModel = GenreResponseModel.fromJson(tGenreJson);

    test(
      '''should perform a GET request on a URL with the API Key 
      in query parameters and with the application/json header''',
      () async {
        // arrange
        when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (_) async => http.Response(fixture('genres_response.json'), 200));

        // act
        await dataSourceImpl.getMovieGenres();

        // assert
        verify(
          mockClient.get(
            Uri.https('api.themoviedb.org', '/3/genre/movie/list', {
              'api_key': tmdbApiKey,
            }),
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        );
      },
    );

    test(
      'should return a GenreResponse when the status code is 200 (success)',
      () async {
        // arrange
        when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (_) async => http.Response(fixture('genres_response.json'), 200));

        // act
        final result = await dataSourceImpl.getMovieGenres();

        // assert
        expect(result, tGenreResponseModel);
      },
    );

    test(
      'should throw a ServerException when the status code is 404 or other',
      () async {
        // arrange
        when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (_) async => http.Response('Something went wrong', 404));

        // act
        final call = dataSourceImpl.getMovieGenres;

        // assert
        expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });

  group('getMoviesByGenre', () {
    const tGenreId = 1;

    test(
      '''should perform a GET request on a URL with the API Key 
      and with_genres with the genre id in query parameters and 
      with the application/json header''',
      () async {
        // arrange
        when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (_) async => http.Response(fixture('movies_response.json'), 200));

        // act
        await dataSourceImpl.getMoviesByGenre(tGenreId);

        // assert
        verify(
          mockClient.get(
            Uri.https('api.themoviedb.org', '/3/discover/movie', {
              'api_key': tmdbApiKey,
              'with_genres': '$tGenreId',
            }),
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        );
      },
    );

    test(
      'should return a MovieResponse when the status code is 200 (success)',
      () async {
        // arrange
        when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (_) async => http.Response(fixture('movies_response.json'), 200));

        // act
        final result = await dataSourceImpl.getMoviesByGenre(tGenreId);

        // assert
        expect(result, tMovieResponseModel);
      },
    );

    test(
      'should throw a ServerException when the status code is 404 or other',
      () async {
        // arrange
        when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (_) async => http.Response('Something went wrong', 404));

        // act
        final call = dataSourceImpl.getMoviesByGenre;

        // assert
        expect(
          () => call(tGenreId),
          throwsA(const TypeMatcher<ServerException>()),
        );
      },
    );
  });

  group('getMoviesByTitle', () {
    const tTitle = 'batman';

    test(
      '''should perform a GET request on a URL with the API Key 
      and query with the encoded title in query parameters and 
      with the application/json header''',
      () async {
        // arrange
        when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (_) async => http.Response(fixture('movies_response.json'), 200));

        // act
        await dataSourceImpl.getMoviesByTitle(tTitle);

        // assert
        verify(
          mockClient.get(
            Uri.https('api.themoviedb.org', '/3/search/movie', {
              'api_key': tmdbApiKey,
              'query': Uri.encodeComponent(tTitle),
            }),
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        );
      },
    );

    test(
      'should return a MovieResponse when the status code is 200 (success)',
      () async {
        // arrange
        when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (_) async => http.Response(fixture('movies_response.json'), 200));

        // act
        final result = await dataSourceImpl.getMoviesByTitle(tTitle);

        // assert
        expect(result, tMovieResponseModel);
      },
    );

    test(
      'should throw a ServerException when the status code is 404 or other',
      () async {
        // arrange
        when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (_) async => http.Response('Something went wrong', 404));

        // act
        final call = dataSourceImpl.getMoviesByTitle;

        // assert
        expect(
          () => call(tTitle),
          throwsA(const TypeMatcher<ServerException>()),
        );
      },
    );
  });
}
