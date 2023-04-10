import 'package:flutter/material.dart';

import 'package:movies_app/features/movies/domain/entities/movie.dart';

class MoviesGrid extends StatelessWidget {
  final List<Movie> movies;

  const MoviesGrid({
    super.key,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 9 / 16),
      itemCount: movies.length,
      itemBuilder: (context, index) => MovieCard(movie: movies[index]),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: FadeInImage(
        imageSemanticLabel: '${movie.title} poster',
        placeholder: const AssetImage('images/poster-placeholder.png'),
        image: NetworkImage(movie.fullPosterPath),
        imageErrorBuilder: (context, error, stackTrace) => Image.asset(
          'images/poster-placeholder.png',
        ),
        fit: BoxFit.cover,
      ),
    );
  }
}
