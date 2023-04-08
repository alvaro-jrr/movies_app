import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:movies_app/features/movies/data/models/genre_model.dart';
import 'package:movies_app/features/movies/data/models/genre_response_model.dart';
import 'package:movies_app/features/movies/domain/entities/genre_response.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tGenreResponseModel = GenreResponseModel(
    genres: [GenreModel(id: 1, name: 'Test')],
  );

  test(
    'should be a subclass of GenreResponse entity',
    () async {
      // assert
      expect(tGenreResponseModel, isA<GenreResponse>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final jsonMap = jsonDecode(fixture('genres_response.json'));

        // act
        final result = GenreResponseModel.fromJson(jsonMap);

        // assert
        expect(result, tGenreResponseModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tGenreResponseModel.toJson();

        // assert
        expect(result, {
          'genres': [
            {
              'id': 1,
              'name': 'Test',
            }
          ]
        });
      },
    );
  });

  group('genres', () {
    test(
      'should return a GenreModel list',
      () async {
        // assert
        expect(tGenreResponseModel.genres, isA<List<GenreModel>>());
      },
    );
  });
}
