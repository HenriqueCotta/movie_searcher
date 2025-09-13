import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_searcher/data/models/movie_dto.dart';
import 'package:movie_searcher/data/repositories/movies_repository.dart';
import 'package:movie_searcher/data/services/movie_service.dart';

class MockMovieService extends Mock implements MovieService {}

void main() {
  late MovieService svc;
  late MoviesRepository repo;

  setUp(() {
    svc = MockMovieService();
    repo = MoviesRepository(svc);
  });

  test('search mapeia DTO -> entidade com campos básicos', () async {
    when(() => svc.fetchMovies('matrix')).thenAnswer(
      (_) async => [
        MovieDto(
          imdbId: 'tt0133093',
          title: 'The Matrix',
          year: '1999',
          poster: 'p',
          genre: '',
          plot: '',
        ),
      ],
    );

    final list = await repo.search('matrix');
    expect(list, hasLength(1));
    expect(list.first.id, 'tt0133093');
    expect(list.first.genre, '');
  });

  test('getById mapeia DTO completo -> entidade com genre/plot', () async {
    when(() => svc.fetchMovieById('tt0133093')).thenAnswer(
      (_) async => MovieDto(
        imdbId: 'tt0133093',
        title: 'The Matrix',
        year: '1999',
        poster: 'p',
        genre: 'Action, Sci-Fi',
        plot: 'Long plot...',
      ),
    );

    final m = await repo.getById('tt0133093');
    expect(m.genre, contains('Action'));
    expect(m.plot, contains('Long'));
  });
}
