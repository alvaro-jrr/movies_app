import 'package:flutter/material.dart';

import 'package:movies_app/features/movies/domain/entities/movie.dart';
import 'package:movies_app/features/movies/presentation/pages/pages.dart';

class MoviesGrid extends StatelessWidget {
  final List<Movie> movies;
  final String title;

  const MoviesGrid({
    super.key,
    required this.movies,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'FamiljenGrotesk',
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 9 / 16,
          ),
          itemCount: movies.length,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () async {
              await Navigator.pushNamed(
                context,
                MoviePage.routeName,
                arguments: movies[index],
              );

              // Remove focus when returning to previous page.
              if (FocusManager.instance.primaryFocus != null) {
                FocusManager.instance.primaryFocus!.unfocus();
              }
            },
            child: _MoviePoster(movies[index]),
          ),
        ),
      ],
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final Movie movie;

  const _MoviePoster(this.movie);

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
