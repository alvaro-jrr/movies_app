import 'package:flutter/material.dart';

import 'package:movies_app/features/movies/domain/entities/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard(this.movie, {super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return _MovieBackground(
      semanticLabel: '${movie.title} poster',
      imageUrl: movie.fullPosterPath,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        width: size.width,
        child: Text(
          movie.title,
          maxLines: 2,
          overflow: TextOverflow.fade,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 32,
            fontFamily: 'FamiljenGrotesk',
          ),
        ),
      ),
    );
  }
}

class _MovieBackground extends StatelessWidget {
  final String? semanticLabel;
  final String imageUrl;
  final Widget child;

  const _MovieBackground({
    required this.imageUrl,
    required this.child,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          foregroundDecoration: BoxDecoration(
            color: Colors.black.withOpacity(0.35),
          ),
          child: FadeInImage(
            placeholder: const AssetImage('images/poster-placeholder.png'),
            image: NetworkImage(imageUrl),
            imageErrorBuilder: (context, error, stackTrace) {
              return Image.asset('images/poster-placeholder.png');
            },
            fit: BoxFit.cover,
            width: double.infinity,
            imageSemanticLabel: semanticLabel ?? 'Movie Poster',
          ),
        ),
        Positioned(bottom: 64, child: child),
      ],
    );
  }
}
