import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movies_app/features/movies/presentation/bloc/movies_bloc.dart';
import 'package:movies_app/features/movies/presentation/widgets/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff000d22),
      body: SafeArea(
        child: SingleChildScrollView(
          child: _Body(),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header.
        _Header(),
        const SizedBox(height: 24),
        // Search.
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: SearchMovieControls(),
        ),
        const SizedBox(height: 24),
        // Categories.
        const Placeholder(fallbackHeight: 48),
        const SizedBox(height: 24),
        // Movies.
        const Placeholder(fallbackHeight: 600),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.6,
      width: double.infinity,
      child: BlocBuilder<MoviesBloc, MoviesState>(
        builder: (context, state) {
          if (state is Loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is Error) {
            return Center(child: Text(state.message));
          }

          if (state is LoadedMovies) {
            final movies = state.movieResponse.results.sublist(0, 5);

            return MovieSwiper(movies: movies);
          }

          // Start loading process.
          addPopularMovies(context);
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void addPopularMovies(BuildContext context) {
    BlocProvider.of<MoviesBloc>(context, listen: false)
        .add(GetMoviesFromPopulars());
  }
}
