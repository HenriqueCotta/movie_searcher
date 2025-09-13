import 'package:movie_searcher/data/models/movie_dto.dart';
import 'package:movie_searcher/data/services/movie_service.dart';
import 'package:movie_searcher/domain/models/movie.dart';

class MoviesRepository {
  final MovieService service;
  MoviesRepository(this.service);

  Future<List<Movie>> search(String query) async {
    final List<MovieDto> dtos = await service.fetchMovies(query);
    return dtos
        .map((d) => Movie(id: d.imdbId, title: d.title, year: d.year, poster: d.poster))
        .toList();
  }

  Future<Movie> getById(String imdbId) async {
    final d = await service.fetchMovieById(imdbId);
    return Movie(
      id: d.imdbId,
      title: d.title,
      year: d.year,
      poster: d.poster,
      genre: d.genre,
      plot: d.plot,
    );
  }
}
