import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:movies_app/core/error/failures.dart';
import 'package:movies_app/core/use_cases/use_case.dart';
import 'package:movies_app/features/movies/domain/entities/genre_response.dart';
import 'package:movies_app/features/movies/domain/entities/genre.dart';
import 'package:movies_app/features/movies/domain/entities/movie_response.dart';
import 'package:movies_app/features/movies/domain/entities/movie.dart';
import 'package:movies_app/features/movies/domain/use_cases/get_movie_genres.dart';
import 'package:movies_app/features/movies/domain/use_cases/get_movies_by_genre.dart';
import 'package:movies_app/features/movies/domain/use_cases/get_movies_by_title.dart';
import 'package:movies_app/features/movies/domain/use_cases/get_popular_movies.dart';
import 'package:movies_app/features/movies/presentation/bloc/movies_bloc.dart';

@GenerateNiceMocks([
  MockSpec<GetPopularMovies>(),
  MockSpec<GetMovieGenres>(),
  MockSpec<GetMoviesByGenre>(),
  MockSpec<GetMoviesByTitle>(),
])
import 'movies_bloc_test.mocks.dart';

void main() {
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetMovieGenres mockGetMovieGenres;
  late MockGetMoviesByGenre mockGetMoviesByGenre;
  late MockGetMoviesByTitle mockGetMoviesByTitle;
  late MoviesBloc bloc;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetMovieGenres = MockGetMovieGenres();
    mockGetMoviesByGenre = MockGetMoviesByGenre();
    mockGetMoviesByTitle = MockGetMoviesByTitle();

    bloc = MoviesBloc(
      getPopularMovies: mockGetPopularMovies,
      getMovieGenres: mockGetMovieGenres,
      getMoviesByGenre: mockGetMoviesByGenre,
      getMoviesByTitle: mockGetMoviesByTitle,
    );
  });

  test(
    'initial state is Empty',
    () async {
      // assert
      expect(bloc.state, Empty());
    },
  );

  const tMovieResponse = MovieResponse(
    page: 1,
    results: [
      Movie(
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

  group('GetMoviesFromPopulars', () {
    test(
      'should get data from populars',
      () async {
        // arrange
        when(mockGetPopularMovies(any))
            .thenAnswer((_) async => const Right(tMovieResponse));

        // act
        bloc.add(GetMoviesFromPopulars());
        await untilCalled(mockGetPopularMovies(any));

        // assert
        verify(mockGetPopularMovies(NoParams()));
      },
    );
    test(
      'should emit [Loading, LoadedMovies] when data is gotten successfully',
      () async {
        // arrange
        when(mockGetPopularMovies(any))
            .thenAnswer((_) async => const Right(tMovieResponse));

        // assert later
        final expected = [
          Loading(),
          const LoadedMovies(
            movieResponse: tMovieResponse,
          ),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(GetMoviesFromPopulars());
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // arrange
        when(mockGetPopularMovies(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          Loading(),
          const Error(message: serverFailureMessage),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(GetMoviesFromPopulars());
      },
    );

    test(
      'should emit [Loading, Error] with a proper message when getting data fails',
      () async {
        // arrange
        when(mockGetPopularMovies(any))
            .thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        final expected = [
          Loading(),
          const Error(message: cacheFailureMessage),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(GetMoviesFromPopulars());
      },
    );
  });

  group('GetGenresForMovies', () {
    const tGenreResponse = GenreResponse(genres: [Genre(id: 1, name: 'Test')]);

    test(
      'should get data with movie genres',
      () async {
        // arrange
        when(mockGetMovieGenres(any))
            .thenAnswer((_) async => const Right(tGenreResponse));

        // act
        bloc.add(GetGenresForMovies());
        await untilCalled(mockGetMovieGenres(any));

        // assert
        verify(mockGetMovieGenres(NoParams()));
      },
    );
    test(
      'should emit [Loading, LoadedMovies] when data is gotten successfully',
      () async {
        // arrange
        when(mockGetMovieGenres(any))
            .thenAnswer((_) async => const Right(tGenreResponse));

        // assert later
        final expected = [
          Loading(),
          const LoadedGenres(genreResponse: tGenreResponse),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(GetGenresForMovies());
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // arrange
        when(mockGetMovieGenres(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          Loading(),
          const Error(message: serverFailureMessage),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(GetGenresForMovies());
      },
    );

    test(
      'should emit [Loading, Error] with a proper message when getting data fails',
      () async {
        // arrange
        when(mockGetMovieGenres(any))
            .thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        final expected = [
          Loading(),
          const Error(message: cacheFailureMessage),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(GetGenresForMovies());
      },
    );
  });

  group('GetMoviesFromGenre', () {
    const tGenreId = 1;

    test(
      'should get data from an specific genre',
      () async {
        // arrange
        when(mockGetMoviesByGenre(any))
            .thenAnswer((_) async => const Right(tMovieResponse));

        // act
        bloc.add(const GetMoviesFromGenre(tGenreId));
        await untilCalled(mockGetMoviesByGenre(any));

        // assert
        verify(mockGetMoviesByGenre(
          const GetMoviesByGenreParams(id: tGenreId),
        ));
      },
    );

    test(
      'should emit [Loading, LoadedMovies] when data is gotten successfully',
      () async {
        // arrange
        when(mockGetMoviesByGenre(any))
            .thenAnswer((_) async => const Right(tMovieResponse));

        // assert later
        final expected = [
          Loading(),
          const LoadedMovies(
            movieResponse: tMovieResponse,
          ),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const GetMoviesFromGenre(tGenreId));
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // arrange
        when(mockGetMoviesByGenre(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          Loading(),
          const Error(message: serverFailureMessage),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const GetMoviesFromGenre(tGenreId));
      },
    );

    test(
      'should emit [Loading, Error] with a proper message when getting data fails',
      () async {
        // arrange
        when(mockGetMoviesByGenre(any))
            .thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        final expected = [
          Loading(),
          const Error(message: cacheFailureMessage),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const GetMoviesFromGenre(tGenreId));
      },
    );
  });

  group('GetMoviesFromTitle', () {
    const tTitle = 'Test';

    test(
      'should get data with the title',
      () async {
        // arrange
        when(mockGetMoviesByTitle(any))
            .thenAnswer((_) async => const Right(tMovieResponse));

        // act
        bloc.add(const GetMoviesFromTitle(tTitle));
        await untilCalled(mockGetMoviesByTitle(any));

        // assert
        verify(
          mockGetMoviesByTitle(const GetMoviesByTitleParams(title: tTitle)),
        );
      },
    );

    test(
      'should emit [Loading, LoadedMovies] when data is gotten successfully',
      () async {
        // arrange
        when(mockGetMoviesByTitle(any))
            .thenAnswer((_) async => const Right(tMovieResponse));

        // assert later
        final expected = [
          Loading(),
          const LoadedMovies(
            movieResponse: tMovieResponse,
          ),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const GetMoviesFromTitle(tTitle));
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // arrange
        when(mockGetMoviesByTitle(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          Loading(),
          const Error(message: serverFailureMessage),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const GetMoviesFromTitle(tTitle));
      },
    );

    test(
      'should emit [Loading, Error] with a proper message when getting data fails',
      () async {
        // arrange
        when(mockGetMoviesByTitle(any))
            .thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        final expected = [
          Loading(),
          const Error(message: cacheFailureMessage),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const GetMoviesFromTitle(tTitle));
      },
    );
  });
}
