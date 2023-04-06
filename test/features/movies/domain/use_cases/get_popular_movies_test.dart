import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:movies_app/core/use_cases/use_case.dart';
import 'package:movies_app/features/movies/domain/entities/movie.dart';
import 'package:movies_app/features/movies/domain/repositories/movies_repository.dart';
import 'package:movies_app/features/movies/domain/use_cases/get_popular_movies.dart';

@GenerateNiceMocks([MockSpec<MoviesRepository>()])
import 'get_popular_movies_test.mocks.dart';

void main() {
  late MockMoviesRepository mockMoviesRepository;
  late GetPopularMovies useCase;

  setUp(() {
    mockMoviesRepository = MockMoviesRepository();
    useCase = GetPopularMovies(mockMoviesRepository);
  });

  const tPopularMovies = [
    Movie(
      id: 1,
      originalTitle: 'Test',
      overview: 'Test',
      posterPath: 'Test',
      title: 'Test',
      voteAverage: 1,
    ),
  ];

  test(
    'should get popular movies from the repository',
    () async {
      // arrange
      when(mockMoviesRepository.getPopularMovies())
          .thenAnswer((_) async => const Right(tPopularMovies));

      // act
      final result = await useCase(NoParams());

      // assert
      verify(mockMoviesRepository.getPopularMovies());
      expect(result, const Right(tPopularMovies));
      verifyNoMoreInteractions(mockMoviesRepository);
    },
  );
}
