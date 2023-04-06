import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:movies_app/features/movies/domain/entities/movie.dart';
import 'package:movies_app/features/movies/domain/repositories/movies_repository.dart';
import 'package:movies_app/features/movies/domain/use_cases/get_movies_by_genre.dart';

@GenerateNiceMocks([MockSpec<MoviesRepository>()])
import 'get_movies_by_genre_test.mocks.dart';

void main() {
  late MockMoviesRepository mockMoviesRepository;
  late GetMoviesByGenre useCase;

  setUp(() {
    mockMoviesRepository = MockMoviesRepository();
    useCase = GetMoviesByGenre(mockMoviesRepository);
  });

  const tMoviesByGenre = [
    Movie(
      id: 1,
      originalTitle: 'Test',
      overview: 'Test',
      popularity: 1,
      posterPath: 'Test',
      title: 'Test',
      voteAverage: 1,
    ),
  ];

  const tGenreId = 1;

  test(
    'should get movies by genre from the repository',
    () async {
      // arrange
      when(mockMoviesRepository.getMoviesByGenre(any))
          .thenAnswer((_) async => const Right(tMoviesByGenre));

      // act
      final result = await useCase(const Params(id: tGenreId));

      // assert
      verify(mockMoviesRepository.getMoviesByGenre(tGenreId));
      expect(result, const Right(tMoviesByGenre));
      verifyNoMoreInteractions(mockMoviesRepository);
    },
  );
}
