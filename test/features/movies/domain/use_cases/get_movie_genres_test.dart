import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:movies_app/core/use_cases/use_case.dart';
import 'package:movies_app/features/movies/domain/entities/genre.dart';
import 'package:movies_app/features/movies/domain/repositories/movies_repository.dart';
import 'package:movies_app/features/movies/domain/use_cases/get_movie_genres.dart';

@GenerateNiceMocks([MockSpec<MoviesRepository>()])
import 'get_movie_genres_test.mocks.dart';

void main() {
  late MockMoviesRepository mockMoviesRepository;
  late GetMovieGenres useCase;

  setUp(() {
    mockMoviesRepository = MockMoviesRepository();
    useCase = GetMovieGenres(mockMoviesRepository);
  });

  const tGenres = [Genre(id: 1, name: 'Test')];

  test(
    'should get movie genres from the repository',
    () async {
      // arrange
      when(mockMoviesRepository.getMovieGenres())
          .thenAnswer((_) async => const Right(tGenres));

      // act
      final result = await useCase(NoParams());

      // assert
      verify(mockMoviesRepository.getMovieGenres());
      expect(result, const Right(tGenres));
      verifyNoMoreInteractions(mockMoviesRepository);
    },
  );
}
