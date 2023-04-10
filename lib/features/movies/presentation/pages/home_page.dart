import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movies_app/features/movies/domain/entities/movie.dart';
import 'package:movies_app/features/movies/domain/entities/genre.dart';
import 'package:movies_app/features/movies/presentation/bloc/movies_bloc.dart';
import 'package:movies_app/features/movies/presentation/widgets/widgets.dart';

class HomePage extends StatelessWidget {
  static const String routeName = 'home';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: _Body(),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoviesBloc, MoviesState>(
      builder: (context, state) {
        if (state is Loading) {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is Error) {
          return Center(
            child: Text(state.message),
          );
        }

        if (state is Loaded) {
          final movies = state.movieResponse.results;
          final genres = state.genreResponse.genres;

          return _Content(movies: movies, genres: genres);
        }

        addPopularAndMovieGenres(context);
        return Container();
      },
    );
  }

  void addPopularAndMovieGenres(BuildContext context) {
    BlocProvider.of<MoviesBloc>(context).add(GetPopularAndMovieGenres());
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.movies,
    required this.genres,
  });

  final List<Movie> movies;
  final List<Genre> genres;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header.
        MovieSwiper(movies: movies.sublist(0, 5)),
        const SizedBox(height: 32),
        // Search.
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: SearchMovieControls(),
        ),
        const SizedBox(height: 24),
        // Categories.
        MovieGenres(genres: genres),
        const SizedBox(height: 32),
        // Movies.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: MoviesGrid(
            movies: movies,
            title: 'Populars Now',
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
