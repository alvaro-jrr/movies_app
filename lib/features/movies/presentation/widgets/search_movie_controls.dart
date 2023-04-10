import 'package:flutter/material.dart';

class SearchMovieControls extends StatefulWidget {
  const SearchMovieControls({
    super.key,
  });

  @override
  State<SearchMovieControls> createState() => _SearchMovieControlsState();
}

class _SearchMovieControlsState extends State<SearchMovieControls> {
  final controller = TextEditingController();

  String inputTitle = '';

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: (value) => inputTitle = value,
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
