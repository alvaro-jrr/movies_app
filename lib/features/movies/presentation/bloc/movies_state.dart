part of 'movies_bloc.dart';

abstract class MoviesState extends Equatable {
  const MoviesState();

  @override
  List<Object> get props => [];
}

class Empty extends MoviesState {}

class Loading extends MoviesState {}

class Loaded extends MoviesState {
  final MovieResponse movieResponse;
  final GenreResponse genreResponse;

  const Loaded({
    required this.movieResponse,
    required this.genreResponse,
  });

  @override
  List<Object> get props => [movieResponse, genreResponse];
}

class LoadedMovies extends MoviesState {
  final MovieResponse movieResponse;

  const LoadedMovies({required this.movieResponse});

  @override
  List<Object> get props => [movieResponse];
}

class LoadedGenres extends MoviesState {
  final GenreResponse genreResponse;

  const LoadedGenres({
    required this.genreResponse,
  });

  @override
  List<Object> get props => [genreResponse];
}

class Error extends MoviesState {
  final String message;

  const Error({required this.message});

  @override
  List<Object> get props => [message];
}
