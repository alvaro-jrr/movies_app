import 'package:flutter/material.dart';

class SearchMovieControls extends StatelessWidget {
  const SearchMovieControls({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: const Icon(Icons.search),
      ),
    );
  }
}
