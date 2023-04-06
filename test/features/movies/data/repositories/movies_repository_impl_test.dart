import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies_app/core/error/exceptions.dart';
import 'package:movies_app/core/error/failures.dart';

import 'package:movies_app/core/utils/network_info.dart';
import 'package:movies_app/features/movies/data/data_sources/movies_local_data_source.dart';
import 'package:movies_app/features/movies/data/data_sources/movies_remote_data_source.dart';
import 'package:movies_app/features/movies/data/models/genre_model.dart';
import 'package:movies_app/features/movies/data/models/movie_model.dart';
import 'package:movies_app/features/movies/data/repositories/movies_repository_impl.dart';

@GenerateNiceMocks([
  MockSpec<MoviesLocalDataSource>(),
  MockSpec<MoviesRemoteDataSource>(),
  MockSpec<NetworkInfo>(),
])
import 'movies_repository_impl_test.mocks.dart';

void main() {
  late MockMoviesLocalDataSource mockLocalDataSource;
  late MockMoviesRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late MoviesRepositoryImpl repository;

  setUp(() {
    mockLocalDataSource = MockMoviesLocalDataSource();
    mockRemoteDataSource = MockMoviesRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = MoviesRepositoryImpl(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runOnlineTests(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runOfflineTests(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getPopularMovies', () {
    const tMovieModels = [
      MovieModel(
        id: 1,
        originalTitle: 'Test',
        overview: 'Test',
        posterPath: 'Test',
        title: 'Test',
        voteAverage: 1,
      ),
    ];

    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        // act
        await repository.getPopularMovies();

        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runOnlineTests(() {
      test(
        'should return remote data when the call to remote data source is successfull',
        () async {
          // arrange
          when(mockRemoteDataSource.getPopularMovies())
              .thenAnswer((_) async => tMovieModels);

          // act
          final result = await repository.getPopularMovies();

          // assert
          verify(mockRemoteDataSource.getPopularMovies());
          expect(result, equals(const Right(tMovieModels)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successfull',
        () async {
          // arrange
          when(mockRemoteDataSource.getPopularMovies())
              .thenAnswer((_) async => tMovieModels);

          // act
          await repository.getPopularMovies();

          // assert
          verify(mockRemoteDataSource.getPopularMovies());
          verify(mockLocalDataSource.cacheMovies(tMovieModels));
        },
      );

      test(
        'should return ServerFailure when the call to remote data source is unsuccessfull',
        () async {
          // arrange
          when(mockRemoteDataSource.getPopularMovies())
              .thenThrow(ServerException());

          // act
          final result = await repository.getPopularMovies();

          // assert
          verify(mockRemoteDataSource.getPopularMovies());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runOfflineTests(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastMovies()).thenThrow(CacheException());

          // act
          final result = await repository.getPopularMovies();

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastMovies());
          expect(result, Left(CacheFailure()));
        },
      );

      test(
        'should return CacheFailure when the cached data is not present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastMovies())
              .thenAnswer((_) async => tMovieModels);

          // act
          final result = await repository.getPopularMovies();

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastMovies());
          expect(result, const Right(tMovieModels));
        },
      );
    });
  });

  group('getPopularMovies', () {
    const tMovieModels = [
      MovieModel(
        id: 1,
        originalTitle: 'Test',
        overview: 'Test',
        posterPath: 'Test',
        title: 'Test',
        voteAverage: 1,
      ),
    ];

    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        // act
        await repository.getPopularMovies();

        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runOnlineTests(() {
      test(
        'should return remote data when the call to remote data source is successfull',
        () async {
          // arrange
          when(mockRemoteDataSource.getPopularMovies())
              .thenAnswer((_) async => tMovieModels);

          // act
          final result = await repository.getPopularMovies();

          // assert
          verify(mockRemoteDataSource.getPopularMovies());
          expect(result, equals(const Right(tMovieModels)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successfull',
        () async {
          // arrange
          when(mockRemoteDataSource.getPopularMovies())
              .thenAnswer((_) async => tMovieModels);

          // act
          await repository.getPopularMovies();

          // assert
          verify(mockRemoteDataSource.getPopularMovies());
          verify(mockLocalDataSource.cacheMovies(tMovieModels));
        },
      );

      test(
        'should return ServerFailure when the call to remote data source is unsuccessfull',
        () async {
          // arrange
          when(mockRemoteDataSource.getPopularMovies())
              .thenThrow(ServerException());

          // act
          final result = await repository.getPopularMovies();

          // assert
          verify(mockRemoteDataSource.getPopularMovies());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runOfflineTests(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastMovies())
              .thenAnswer((_) async => tMovieModels);

          // act
          final result = await repository.getPopularMovies();

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastMovies());
          expect(result, const Right(tMovieModels));
        },
      );

      test(
        'should return CacheFailure when the cached data is not present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastMovies()).thenThrow(CacheException());

          // act
          final result = await repository.getPopularMovies();

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastMovies());
          expect(result, Left(CacheFailure()));
        },
      );
    });
  });

  group('getMovieGenres', () {
    const tGenreModels = [GenreModel(id: 1, name: 'Test')];

    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        // act
        await repository.getMovieGenres();

        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runOnlineTests(() {
      test(
        'should return remote data when the call to remote data source is successfull',
        () async {
          // arrange
          when(mockRemoteDataSource.getMovieGenres())
              .thenAnswer((_) async => tGenreModels);

          // act
          final result = await repository.getMovieGenres();

          // assert
          verify(mockRemoteDataSource.getMovieGenres());
          expect(result, equals(const Right(tGenreModels)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successfull',
        () async {
          // arrange
          when(mockRemoteDataSource.getMovieGenres())
              .thenAnswer((_) async => tGenreModels);

          // act
          await repository.getMovieGenres();

          // assert
          verify(mockRemoteDataSource.getMovieGenres());
          verify(mockLocalDataSource.cacheGenres(tGenreModels));
        },
      );

      test(
        'should return ServerFailure when the call to remote data source is unsuccessfull',
        () async {
          // arrange
          when(mockRemoteDataSource.getMovieGenres())
              .thenThrow(ServerException());

          // act
          final result = await repository.getMovieGenres();

          // assert
          verify(mockRemoteDataSource.getMovieGenres());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runOfflineTests(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastGenres())
              .thenAnswer((_) async => tGenreModels);

          // act
          final result = await repository.getMovieGenres();

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastGenres());
          expect(result, const Right(tGenreModels));
        },
      );

      test(
        'should return CacheFailure when the cached data is not present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastGenres()).thenThrow(CacheException());

          // act
          final result = await repository.getMovieGenres();

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastGenres());
          expect(result, Left(CacheFailure()));
        },
      );
    });
  });

  group('getMoviesByGenre', () {
    const tGenreId = 1;

    const tMovieModels = [
      MovieModel(
        id: 1,
        originalTitle: 'Test',
        overview: 'Test',
        posterPath: 'Test',
        title: 'Test',
        voteAverage: 1,
      ),
    ];

    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        // act
        await repository.getMoviesByGenre(tGenreId);

        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runOnlineTests(() {
      test(
        'should return remote data when the call to remote data source is successfull',
        () async {
          // arrange
          when(mockRemoteDataSource.getMoviesByGenre(any))
              .thenAnswer((_) async => tMovieModels);

          // act
          final result = await repository.getMoviesByGenre(tGenreId);

          // assert
          verify(mockRemoteDataSource.getMoviesByGenre(tGenreId));
          expect(result, equals(const Right(tMovieModels)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successfull',
        () async {
          // arrange
          when(mockRemoteDataSource.getMoviesByGenre(any))
              .thenAnswer((_) async => tMovieModels);

          // act
          await repository.getMoviesByGenre(tGenreId);

          // assert
          verify(mockRemoteDataSource.getMoviesByGenre(tGenreId));
          verify(mockLocalDataSource.cacheMovies(tMovieModels));
        },
      );

      test(
        'should return ServerFailure when the call to remote data source is unsuccessfull',
        () async {
          // arrange
          when(mockRemoteDataSource.getMoviesByGenre(any))
              .thenThrow(ServerException());

          // act
          final result = await repository.getMoviesByGenre(tGenreId);

          // assert
          verify(mockRemoteDataSource.getMoviesByGenre(tGenreId));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runOfflineTests(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastMovies())
              .thenAnswer((_) async => tMovieModels);

          // act
          final result = await repository.getMoviesByGenre(tGenreId);

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastMovies());
          expect(result, const Right(tMovieModels));
        },
      );

      test(
        'should return CacheFailure when the cached data is not present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastMovies()).thenThrow(CacheException());

          // act
          final result = await repository.getMoviesByGenre(tGenreId);

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastMovies());
          expect(result, Left(CacheFailure()));
        },
      );
    });
  });

  group('getMoviesByTitle', () {
    const tTitle = 'Test';

    const tMovieModels = [
      MovieModel(
        id: 1,
        originalTitle: 'Test',
        overview: 'Test',
        posterPath: 'Test',
        title: 'Test',
        voteAverage: 1,
      ),
    ];

    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        // act
        await repository.getMoviesByTitle(tTitle);

        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runOnlineTests(() {
      test(
        'should return remote data when the call to remote data source is successfull',
        () async {
          // arrange
          when(mockRemoteDataSource.getMoviesByTitle(any))
              .thenAnswer((_) async => tMovieModels);

          // act
          final result = await repository.getMoviesByTitle(tTitle);

          // assert
          verify(mockRemoteDataSource.getMoviesByTitle(tTitle));
          expect(result, equals(const Right(tMovieModels)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successfull',
        () async {
          // arrange
          when(mockRemoteDataSource.getMoviesByTitle(any))
              .thenAnswer((_) async => tMovieModels);

          // act
          await repository.getMoviesByTitle(tTitle);

          // assert
          verify(mockRemoteDataSource.getMoviesByTitle(tTitle));
          verify(mockLocalDataSource.cacheMovies(tMovieModels));
        },
      );

      test(
        'should return ServerFailure when the call to remote data source is unsuccessfull',
        () async {
          // arrange
          when(mockRemoteDataSource.getMoviesByTitle(any))
              .thenThrow(ServerException());

          // act
          final result = await repository.getMoviesByTitle(tTitle);

          // assert
          verify(mockRemoteDataSource.getMoviesByTitle(tTitle));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runOfflineTests(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastMovies())
              .thenAnswer((_) async => tMovieModels);

          // act
          final result = await repository.getMoviesByTitle(tTitle);

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastMovies());
          expect(result, const Right(tMovieModels));
        },
      );

      test(
        'should return CacheFailure when the cached data is not present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastMovies()).thenThrow(CacheException());

          // act
          final result = await repository.getMoviesByTitle(tTitle);

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastMovies());
          expect(result, Left(CacheFailure()));
        },
      );
    });
  });
}
