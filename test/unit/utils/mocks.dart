import 'package:mocktail/mocktail.dart';
import 'package:movie_searcher/data/repositories/movies_repository.dart';
import 'package:movie_searcher/data/services/local_store_service.dart';
import 'package:movie_searcher/data/services/movie_service.dart';
import 'package:movie_searcher/domain/models/movie.dart';

class MockMoviesRepository extends Mock implements MoviesRepository {}

class MockMovieService extends Mock implements MovieService {}

class MockLocalStoreService extends Mock implements LocalStoreService {}

Movie makeMovie({
  String id = 'tt0133093',
  String title = 'The Matrix',
  String year = '1999',
  String poster = 'https://img/p.jpg',
  String genre = 'Action, Sci-Fi',
  String plot = 'Long plot...',
}) => Movie(id: id, title: title, year: year, poster: poster, genre: genre, plot: plot);
