import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:movies_app/features/movies/data/models/genre_response_model.dart';
import 'package:movies_app/features/movies/data/models/movie_response_model.dart';
import 'package:movies_app/core/error/exceptions.dart';
import 'package:movies_app/features/movies/data/data_sources/movies_local_data_source.dart';

@GenerateNiceMocks([MockSpec<SharedPreferences>()])
import 'movies_local_data_source_test.mocks.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late MoviesLocalDataSourceImpl dataSourceImpl;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSourceImpl = MoviesLocalDataSourceImpl(mockSharedPreferences);
  });

  final tMovieJson = jsonDecode(fixture('movies_cached.json'));
  final tMovieResponseModel = MovieResponseModel.fromJson(tMovieJson);

  final Map<String, dynamic> tGenreJson =
      jsonDecode(fixture('genres_cached.json'));
  final tGenreResponseModel = GenreResponseModel.fromJson(tGenreJson);

  group('getLastMovies', () {
    test(
      'should return a MovieResponse from SharedPreferences when there is one in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('movies_cached.json'));

        // act
        final result = await dataSourceImpl.getLastMovies();

        // assert
        verify(mockSharedPreferences.getString(cachedMoviesKey));
        expect(result, tMovieResponseModel);
      },
    );

    test(
      'should throw a CacheException when there is no data in cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);

        // act
        final call = dataSourceImpl.getLastMovies;

        // assert
        expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheMovies', () {
    test(
      'should call SharedPreferences to cache the data',
      () async {
        // act
        dataSourceImpl.cacheMovies(tMovieResponseModel);

        // assert
        final expectedJsonString = jsonEncode(tMovieResponseModel.toJson());

        verify(mockSharedPreferences.setString(
          cachedMoviesKey,
          expectedJsonString,
        ));
      },
    );
  });

  group('getLastGenres', () {
    test(
      'should return a GenreResponse list from SharedPreferences when there is one in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('genres_cached.json'));

        // act
        final result = await dataSourceImpl.getLastGenres();

        // assert
        verify(mockSharedPreferences.getString(cachedGenresKey));
        expect(result, tGenreResponseModel);
      },
    );

    test(
      'should throw a CacheException when there is no data in cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);

        // act
        final call = dataSourceImpl.getLastGenres;

        // assert
        expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheGenres', () {
    test(
      'should call SharedPreferences to cache the data',
      () async {
        // act
        dataSourceImpl.cacheGenres(tGenreResponseModel);

        // assert
        final expectedJsonString = jsonEncode(tGenreResponseModel.toJson());

        verify(mockSharedPreferences.setString(
          cachedGenresKey,
          expectedJsonString,
        ));
      },
    );
  });
}
