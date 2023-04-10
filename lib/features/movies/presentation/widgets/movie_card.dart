import 'package:flutter/material.dart';

import 'package:movies_app/features/movies/domain/entities/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final double bottomSpace;

  const MovieCard({
    super.key,
    required this.movie,
    required this.bottomSpace,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return _MovieBackground(
      bottom: bottomSpace,
      semanticLabel: '${movie.title} poster',
      imageUrl: movie.fullPosterPath,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
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
            const SizedBox(height: 8),
            _MovieScore(movie.voteAverage),
          ],
        ),
      ),
    );
  }
}

class _MovieScore extends StatelessWidget {
  const _MovieScore(this.voteAverage);

  final double voteAverage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.yellow,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star,
            color: Colors.black,
          ),
          const SizedBox(width: 4),
          Text(
            '$voteAverage',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieBackground extends StatelessWidget {
  final double bottom;
  final String? semanticLabel;
  final String imageUrl;
  final Widget child;

  const _MovieBackground({
    required this.imageUrl,
    required this.child,
    required this.bottom,
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
        Positioned(bottom: bottom, child: child),
      ],
    );
  }
}
