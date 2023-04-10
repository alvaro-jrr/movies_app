import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:movies_app/core/network/network_info.dart';
import 'package:movies_app/features/movies/data/data_sources/movies_local_data_source.dart';
import 'package:movies_app/features/movies/data/data_sources/movies_remote_data_source.dart';
import 'package:movies_app/features/movies/data/repositories/movies_repository_impl.dart';
import 'package:movies_app/features/movies/domain/repositories/movies_repository.dart';
import 'package:movies_app/features/movies/domain/use_cases/get_movie_genres.dart';
import 'package:movies_app/features/movies/domain/use_cases/get_movies_by_genre.dart';
import 'package:movies_app/features/movies/domain/use_cases/get_movies_by_title.dart';
import 'package:movies_app/features/movies/domain/use_cases/get_popular_movies.dart';
import 'package:movies_app/features/movies/presentation/bloc/bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //* Features - Movies
  // Bloc
  sl.registerFactory(
    () => MoviesBloc(
      getPopularMovies: sl(),
      getMovieGenres: sl(),
      getMoviesByGenre: sl(),
      getMoviesByTitle: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetPopularMovies(sl()));
  sl.registerLazySingleton(() => GetMovieGenres(sl()));
  sl.registerLazySingleton(() => GetMoviesByGenre(sl()));
  sl.registerLazySingleton(() => GetMoviesByTitle(sl()));

  // Repository
  sl.registerLazySingleton<MoviesRepository>(
    () => MoviesRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<MoviesLocalDataSource>(
    () => MoviesLocalDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<MoviesRemoteDataSource>(
    () => MoviesRemoteDataSourceImpl(client: sl()),
  );

  //* Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //* External
  final sharedPreferences = await SharedPreferences.getInstance();

  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
