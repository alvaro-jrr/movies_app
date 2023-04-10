import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

import 'package:movies_app/features/movies/domain/entities/movie.dart';
import 'package:movies_app/features/movies/presentation/widgets/widgets.dart';

class MovieSwiper extends StatelessWidget {
  const MovieSwiper({
    super.key,
    required this.movies,
  });

  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.6,
      width: double.infinity,
      child: Swiper(
        onTap: (index) async {
          await Navigator.pushNamed(
            context,
            'movie',
            arguments: movies[index],
          );

          // Remove focus when returning to previous page.
          if (FocusManager.instance.primaryFocus != null) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
        },
        itemCount: movies.length,
        itemBuilder: (context, index) => MovieCard(
          movie: movies[index],
          bottomSpace: 64,
        ),
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
      ),
    );
  }
}
