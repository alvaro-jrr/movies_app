import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:movies_app/features/movies/data/models/genre_model.dart';
import 'package:movies_app/features/movies/domain/entities/genre.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tGenreModel = GenreModel(id: 1, name: 'Test');

  test(
    'should be a subclass of Genre entity',
    () async {
      // assert
      expect(tGenreModel, isA<Genre>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final jsonMap = jsonDecode(fixture('genre.json'));

        // act
        final result = GenreModel.fromJson(jsonMap);

        // assert
        expect(result, tGenreModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tGenreModel.toJson();

        // assert
        expect(result, {"id": 1, "name": "Test"});
      },
    );
  });
}
