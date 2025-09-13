// domain/models/movie.dart
class Movie {
  final String id;
  final String title;
  final String year;
  final String poster;
  final String genre;
  final String plot;

  const Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.poster,
    this.genre = '',
    this.plot = '',
  });
}
