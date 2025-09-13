class MovieDto {
  final String imdbId;
  final String title;
  final String year;
  final String poster;
  final String genre;
  final String plot;

  MovieDto({
    required this.imdbId,
    required this.title,
    required this.year,
    required this.poster,
    required this.genre,
    required this.plot,
  });

  factory MovieDto.fromJson(Map<String, dynamic> j) => MovieDto(
    imdbId: (j['imdbID'] ?? '') as String,
    title: (j['Title'] ?? '') as String,
    year: (j['Year'] ?? '') as String,
    poster: (j['Poster'] ?? '') as String,
    genre: (j['Genre'] ?? '') as String,
    plot: (j['Plot'] ?? '') as String,
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'year': year,
    'imdbId': imdbId,
    'poster': poster,
    'genre': genre,
    'plot': plot,
  };
}
