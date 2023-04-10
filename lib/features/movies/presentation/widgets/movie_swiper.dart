import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

import 'package:movies_app/features/movies/domain/entities/movie.dart';

class MovieSwiper extends StatelessWidget {
  const MovieSwiper({
    super.key,
    required this.movies,
  });

  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    return Swiper(
      itemCount: movies.length,
      itemBuilder: (context, index) => _MovieCard(movies[index]),
      autoplay: true,
      pagination: SwiperPagination(
        alignment: Alignment.bottomRight,
        margin: const EdgeInsets.all(24),
        builder: DotSwiperPaginationBuilder(
          activeColor: Colors.white,
          size: 8,
          activeSize: 8,
          color: Colors.white.withOpacity(0.5),
          space: 4,
        ),
      ),
    );
  }
}

class _MovieCard extends StatelessWidget {
  final Movie movie;

  const _MovieCard(this.movie);

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
            fit: BoxFit.cover,
            width: double.infinity,
            imageSemanticLabel: semanticLabel ?? '',
          ),
        ),
        Positioned(bottom: 64, child: child),
      ],
    );
  }
}
