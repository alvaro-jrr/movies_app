import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:movies_app/core/error/failures.dart';
import 'package:movies_app/core/use_cases/use_case.dart';
import 'package:movies_app/features/movies/domain/entities/genre_response.dart';
import 'package:movies_app/features/movies/domain/entities/movie_response.dart';
import 'package:movies_app/features/movies/domain/use_cases/get_movie_genres.dart';
import 'package:movies_app/features/movies/domain/use_cases/get_movies_by_genre.dart';
import 'package:movies_app/features/movies/domain/use_cases/get_movies_by_title.dart';
import 'package:movies_app/features/movies/domain/use_cases/get_popular_movies.dart';

part 'movies_event.dart';
part 'movies_state.dart';

const serverFailureMessage = 'Server Failure';
const cacheFailureMessage = 'Cache Failure';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final GetPopularMovies getPopularMovies;
  final GetMovieGenres getMovieGenres;
  final GetMoviesByGenre getMoviesByGenre;
  final GetMoviesByTitle getMoviesByTitle;

  MoviesBloc({
    required this.getPopularMovies,
    required this.getMovieGenres,
    required this.getMoviesByGenre,
    required this.getMoviesByTitle,
  }) : super(Empty()) {
    on<GetPopularAndMovieGenres>((event, emit) async {
      emit(Loading());

      final movieResponse = await getPopularMovies(NoParams());
      final genreResponse = await getMovieGenres(NoParams());

      emit(
        movieResponse.fold(
          (failure) => Error(message: _mapFailureToMessage(failure)),
          (movie) {
            return genreResponse.fold(
              (failure) => Error(message: _mapFailureToMessage(failure)),
              (genre) => Loaded(movieResponse: movie, genreResponse: genre),
            );
          },
        ),
      );
    });

    on<GetMoviesFromPopulars>((event, emit) async {
      emit(Loading());

      final movieResponse = await getPopularMovies(NoParams());

      emit(
        movieResponse.fold(
          (failure) => Error(message: _mapFailureToMessage(failure)),
          (movie) => LoadedMovies(movieResponse: movie),
        ),
      );
    });

    on<GetGenresForMovies>((event, emit) async {
      emit(Loading());

      final genreResponse = await getMovieGenres(NoParams());

      emit(
        genreResponse.fold(
          (failure) => Error(message: _mapFailureToMessage(failure)),
          (genre) => LoadedGenres(genreResponse: genre),
        ),
      );
    });

    on<GetMoviesFromGenre>((event, emit) async {
      emit(Loading());

      final movieResponse = await getMoviesByGenre(
        GetMoviesByGenreParams(id: event.genreId),
      );

      emit(
        movieResponse.fold(
          (failure) => Error(message: _mapFailureToMessage(failure)),
          (movie) => LoadedMovies(movieResponse: movie),
        ),
      );
    });

    on<GetMoviesFromTitle>((event, emit) async {
      emit(Loading());

      final movieResponse = await getMoviesByTitle(
        GetMoviesByTitleParams(title: event.title),
      );

      emit(
        movieResponse.fold(
          (failure) => Error(message: _mapFailureToMessage(failure)),
          (movie) => LoadedMovies(movieResponse: movie),
        ),
      );
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;

      case CacheFailure:
        return cacheFailureMessage;

      default:
        return 'Unexpected error';
    }
  }
}
