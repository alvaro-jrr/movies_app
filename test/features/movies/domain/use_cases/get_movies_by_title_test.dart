import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:movies_app/features/movies/domain/entities/movie.dart';
import 'package:movies_app/features/movies/domain/entities/movie_response.dart';
import 'package:movies_app/features/movies/domain/repositories/movies_repository.dart';
import 'package:movies_app/features/movies/domain/use_cases/get_movies_by_title.dart';

@GenerateNiceMocks([MockSpec<MoviesRepository>()])
import 'get_movies_by_title_test.mocks.dart';

void main() {
  late MockMoviesRepository mockMoviesRepository;
  late GetMoviesByTitle useCase;

  setUp(() {
    mockMoviesRepository = MockMoviesRepository();
    useCase = GetMoviesByTitle(mockMoviesRepository);
  });

  const tMovieResponse = MovieResponse(
    page: 1,
    results: [
      Movie(
        id: 1,
        originalTitle: 'Test',
        overview: 'Test',
        posterPath: 'Test',
        title: 'Test',
        voteAverage: 1,
      ),
    ],
    totalPages: 1,
  );

  const tTitle = 'Batman';

  test(
    'should get movies by title from the repository',
    () async {
      // arrange
      when(mockMoviesRepository.getMoviesByTitle(any))
          .thenAnswer((_) async => const Right(tMovieResponse));

      // act
      final result = await useCase(const GetMoviesByTitleParams(title: tTitle));

      // assert
      verify(mockMoviesRepository.getMoviesByTitle(tTitle));
      expect(result, const Right(tMovieResponse));
      verifyNoMoreInteractions(mockMoviesRepository);
    },
  );
}
