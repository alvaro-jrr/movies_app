import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/features/movies/data/models/movie_model.dart';
import 'package:movies_app/features/movies/data/models/movie_response_model.dart';
import 'package:movies_app/features/movies/domain/entities/movie_response.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tMovieResponseModel = MovieResponseModel(
    page: 1,
    results: [
      MovieModel(
        id: 1,
        originalTitle: 'Test',
        overview: 'Test',
        posterPath: 'Test',
        title: 'Test',
        voteAverage: 1.0,
      ),
    ],
    totalPages: 1,
  );

  test(
    'should be subclass of MovieResponse entity',
    () async {
      // assert
      expect(tMovieResponseModel, isA<MovieResponse>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final jsonMap = jsonDecode(fixture('movies_response.json'));

        // act
        final result = MovieResponseModel.fromJson(jsonMap);

        // assert
        expect(result, tMovieResponseModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tMovieResponseModel.toJson();

        // assert
        expect(result, {
          'page': 1,
          'results': [
            {
              'id': 1,
              'original_title': 'Test',
              'overview': 'Test',
              'poster_path': 'Test',
              'title': 'Test',
              'vote_average': 1.0,
              'release_date': null,
            }
          ],
          'total_pages': 1,
        });
      },
    );
  });

  group('results', () {
    test(
      'should return a MovieModel list',
      () async {
        // assert
        expect(tMovieResponseModel.results, isA<List<MovieModel>>());
      },
    );
  });
}
