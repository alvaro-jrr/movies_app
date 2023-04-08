import 'package:movies_app/features/movies/data/models/genre_model.dart';
import 'package:movies_app/features/movies/domain/entities/genre_response.dart';

class GenreResponseModel extends GenreResponse {
  const GenreResponseModel({required super.genres});

  factory GenreResponseModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> genres = json['genres'];

    return GenreResponseModel(
      genres: genres.map((genre) => GenreModel.fromJson(genre)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'genres': genres.map((genre) => genre.toJson()).toList(),
    };
  }

  @override
  List<GenreModel> get genres {
    return super.genres.map((genre) {
      return GenreModel(id: genre.id, name: genre.name);
    }).toList();
  }
}
