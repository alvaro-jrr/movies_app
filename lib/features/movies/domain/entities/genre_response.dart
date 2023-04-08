import 'package:equatable/equatable.dart';
import 'package:movies_app/features/movies/domain/entities/genre.dart';

class GenreResponse extends Equatable {
  final List<Genre> genres;

  const GenreResponse({
    required this.genres,
  });

  @override
  List<Object> get props => [genres];
}
