import 'package:flutter/material.dart';

import 'package:movies_app/features/movies/domain/entities/genre.dart';

class MovieGenres extends StatelessWidget {
  final List<Genre> genres;

  const MovieGenres({super.key, required this.genres});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: MediaQuery.of(context).size.width,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xff142037),
            ),
            child: Text(genres[index].name),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemCount: genres.length,
      ),
    );
  }
}
