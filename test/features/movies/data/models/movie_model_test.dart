import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:movies_app/features/movies/data/models/movie_model.dart';
import 'package:movies_app/features/movies/domain/entities/movie.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tMovieModel = MovieModel(
    id: 1,
    originalTitle: 'Test',
    overview: 'Test',
    posterPath: 'Test',
    title: 'Test',
    voteAverage: 1.0,
    releaseDate: DateTime(2022, 12, 14),
  );

  test(
    'should be a subclass of Movie entity',
    () async {
      // assert
      expect(tMovieModel, isA<Movie>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = jsonDecode(fixture('movie.json'));

        // act
        final result = MovieModel.fromJson(jsonMap);

        // assert
        expect(result, tMovieModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tMovieModel.toJson();

        // assert
        final expectedMap = {
          "id": 1,
          "original_title": "Test",
          "overview": "Test",
          "poster_path": "Test",
          "title": "Test",
          "vote_average": 1.0,
          "release_date": "2022-12-14T00:00:00.000",
        };

        expect(result, expectedMap);
      },
    );
  });
}
