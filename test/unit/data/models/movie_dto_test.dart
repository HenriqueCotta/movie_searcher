import 'package:flutter_test/flutter_test.dart';
import 'package:movie_searcher/data/models/movie_dto.dart';

void main() {
  test('fromJson: payload de busca (Search) mapeia campos básicos e deixa genre/plot vazios', () {
    final json = {'Title': 'The Matrix', 'Year': '1999', 'imdbID': 'tt0133093', 'Poster': 'p'};
    final dto = MovieDto.fromJson(json);
    expect(dto.imdbId, 'tt0133093');
    expect(dto.title, 'The Matrix');
    expect(dto.genre, '');
    expect(dto.plot, '');
  });

  test('fromJson: payload completo (por id) mapeia todos os campos', () {
    final json = {
      'Title': 'The Matrix',
      'Year': '1999',
      'imdbID': 'tt0133093',
      'Poster': 'p',
      'Genre': 'Action, Sci-Fi',
      'Plot': 'Long plot...',
    };
    final dto = MovieDto.fromJson(json);
    expect(dto.genre, contains('Action'));
    expect(dto.plot, contains('Long'));
  });

  test('toJson: exporta com chaves minúsculas esperadas pelo projeto', () {
    final dto = MovieDto(
      imdbId: 'tt0133093',
      title: 'The Matrix',
      year: '1999',
      poster: 'p',
      genre: 'Action',
      plot: 'Plot',
    );
    final j = dto.toJson();
    expect(j['imdbId'], 'tt0133093');
    expect(j['title'], 'The Matrix');
    expect(j['genre'], 'Action');
  });
}
