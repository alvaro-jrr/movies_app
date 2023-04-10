part of 'movies_bloc.dart';

abstract class MoviesEvent extends Equatable {
  const MoviesEvent();

  @override
  List<Object> get props => [];
}

class GetPopularAndMovieGenres extends MoviesEvent {}

class GetMoviesFromPopulars extends MoviesEvent {}

class GetGenresForMovies extends MoviesEvent {}

class GetMoviesFromGenre extends MoviesEvent {
  final int genreId;

  const GetMoviesFromGenre(this.genreId);
}

class GetMoviesFromTitle extends MoviesEvent {
  final String title;

  const GetMoviesFromTitle(this.title);
}
