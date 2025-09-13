import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:movie_searcher/data/services/dio_service.dart';
import 'package:movie_searcher/data/services/movie_service.dart';

void main() {
  test('fetchMovies usa s= e parseia lista Search', () async {
    final dioService = DioService('https://www.omdbapi.com/');
    final adapter = DioAdapter(dio: dioService.dio);
    dioService.dio.httpClientAdapter = adapter;

    adapter.onGet(
      '',
      queryParameters: {'apikey': 'KEY', 's': 'matrix', 'type': 'movie'},
      (server) => server.reply(200, {
        'Search': [
          {'Title': 'The Matrix', 'Year': '1999', 'imdbID': 'tt0133093', 'Poster': 'p'},
        ],
      }),
    );

    final svc = MovieService(dioService, apiKey: 'KEY');
    final list = await svc.fetchMovies('matrix');
    expect(list, hasLength(1));
    expect(list.first.imdbId, 'tt0133093');
  });

  test('fetchMovies sem Search retorna lista vazia', () async {
    final dioService = DioService('https://www.omdbapi.com/');
    final adapter = DioAdapter(dio: dioService.dio);
    dioService.dio.httpClientAdapter = adapter;

    adapter.onGet(
      '',
      queryParameters: {'apikey': 'KEY', 's': 'nada', 'type': 'movie'},
      (server) => server.reply(200, {'Response': 'False', 'Error': 'Movie not found!'}),
    );

    final svc = MovieService(dioService, apiKey: 'KEY');
    final list = await svc.fetchMovies('nada');
    expect(list, isEmpty);
  });

  test('fetchMovieById usa i= e plot=full', () async {
    final dioService = DioService('https://www.omdbapi.com/');
    final adapter = DioAdapter(dio: dioService.dio);
    dioService.dio.httpClientAdapter = adapter;

    adapter.onGet(
      '',
      queryParameters: {'apikey': 'KEY', 'i': 'tt0133093', 'plot': 'full'},
      (server) => server.reply(200, {
        'Title': 'The Matrix',
        'Year': '1999',
        'imdbID': 'tt0133093',
        'Poster': 'p',
        'Genre': 'Action, Sci-Fi',
        'Plot': 'Long plot...',
      }),
    );

    final svc = MovieService(dioService, apiKey: 'KEY');
    final dto = await svc.fetchMovieById('tt0133093');
    expect(dto.genre, contains('Action'));
    expect(dto.plot, contains('Long'));
  });
}
