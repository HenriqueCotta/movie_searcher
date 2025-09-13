import 'package:flutter_test/flutter_test.dart';
import 'package:movie_searcher/domain/models/movie.dart';

void main() {
  test('Movie: defaults de genre/plot são strings vazias', () {
    const m = Movie(id: 'id', title: 't', year: 'y', poster: 'p');
    expect(m.genre, '');
    expect(m.plot, '');
  });

  test('Movie: instancia com todos os campos', () {
    const m = Movie(id: 'id', title: 't', year: 'y', poster: 'p', genre: 'g', plot: 'pl');
    expect(m.genre, 'g');
    expect(m.plot, 'pl');
  });
}
