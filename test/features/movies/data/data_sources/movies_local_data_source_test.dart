import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies_app/core/env/env.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:movies_app/core/error/exceptions.dart';
import 'package:movies_app/features/movies/data/data_sources/movies_local_data_source.dart';
import 'package:movies_app/features/movies/data/models/genre_model.dart';
import 'package:movies_app/features/movies/data/models/movie_model.dart';

@GenerateNiceMocks([
  MockSpec<SharedPreferences>(),
  MockSpec<Env>(),
])
import 'movies_local_data_source_test.mocks.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late MoviesLocalDataSourceImpl dataSourceImpl;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSourceImpl = MoviesLocalDataSourceImpl(mockSharedPreferences);
  });

  group('getLastMovies', () {
    final List<dynamic> tJson = jsonDecode(fixture('movies_cached.json'));
    final tMovieModels = tJson.map((e) => MovieModel.fromJson(e)).toList();

    test(
      'should return a MovieModel list from SharedPreferences when there is one in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('movies_cached.json'));

        // act
        final result = await dataSourceImpl.getLastMovies();

        // assert
        verify(mockSharedPreferences.getString(cachedMoviesKey));
        expect(result, tMovieModels);
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
    const tMovieModels = [
      MovieModel(
        id: 1,
        originalTitle: 'Test',
        overview: 'Test',
        posterPath: 'Test',
        title: 'Test',
        voteAverage: 1.0,
      ),
    ];

    test(
      'should call SharedPreferences to cache the data',
      () async {
        // act
        dataSourceImpl.cacheMovies(tMovieModels);

        // assert
        final expectedJsonString =
            jsonEncode(tMovieModels.map((e) => e.toJson()).toList());

        verify(mockSharedPreferences.setString(
          cachedMoviesKey,
          expectedJsonString,
        ));
      },
    );
  });

  group('getLastGenres', () {
    final List<dynamic> tJson = jsonDecode(fixture('genres_cached.json'));
    final tGenreModels = tJson.map((e) => GenreModel.fromJson(e)).toList();

    test(
      'should return a GenreModel list from SharedPreferences when there is one in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('genres_cached.json'));

        // act
        final result = await dataSourceImpl.getLastGenres();

        // assert
        verify(mockSharedPreferences.getString(cachedGenresKey));
        expect(result, tGenreModels);
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
    const tGenreModels = [GenreModel(id: 1, name: 'Test')];

    test(
      'should call SharedPreferences to cache the data',
      () async {
        // act
        dataSourceImpl.cacheGenres(tGenreModels);

        // assert
        final expectedJsonString =
            jsonEncode(tGenreModels.map((e) => e.toJson()).toList());

        verify(mockSharedPreferences.setString(
          cachedGenresKey,
          expectedJsonString,
        ));
      },
    );
  });
}
