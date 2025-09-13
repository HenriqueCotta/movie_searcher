import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:movie_searcher/ui/movies/view_models/search/search_bloc.dart';
import 'package:movie_searcher/ui/movies/view_models/search/search_event.dart';
import 'package:movie_searcher/ui/movies/view_models/search/search_state.dart';
import 'package:movie_searcher/data/repositories/movies_repository.dart';
import 'package:movie_searcher/domain/models/movie.dart';

class MockMoviesRepository extends Mock implements MoviesRepository {}

void main() {
  late MoviesRepository repo;

  setUp(() {
    repo = MockMoviesRepository();
  });

  test('estado inicial é SearchIdle', () {
    final bloc = SearchBloc(repo);
    expect(bloc.state, const SearchIdle());
    bloc.close();
  });

  blocTest<SearchBloc, SearchState>(
    'SearchSubmitted vazio -> Idle',
    build: () => SearchBloc(repo),
    act: (bloc) => bloc.add(SearchSubmitted('   ')),
    expect: () => [isA<SearchIdle>()],
  );

  blocTest<SearchBloc, SearchState>(
    'SearchSubmitted ok: Loading -> Success',
    build: () {
      when(() => repo.search('matrix')).thenAnswer(
        (_) async => const [Movie(id: 'tt0133093', title: 'The Matrix', year: '1999', poster: 'p')],
      );
      return SearchBloc(repo);
    },
    act: (bloc) => bloc.add(SearchSubmitted('matrix')),
    expect: () => [
      isA<SearchLoading>(),
      isA<SearchSuccess>().having((s) => s.results.length, 'len', 1),
    ],
    verify: (_) => verify(() => repo.search('matrix')).called(1),
  );

  blocTest<SearchBloc, SearchState>(
    'erro: Loading -> Error',
    build: () {
      when(() => repo.search('matrix')).thenThrow(Exception('boom'));
      return SearchBloc(repo);
    },
    act: (bloc) => bloc.add(SearchSubmitted('matrix')),
    expect: () => [isA<SearchLoading>(), isA<SearchError>()],
  );

  // ---- TESTE DE DEBOUNCE REESCRITO (robusto a emissões intermediárias) ----
  test('múltiplos SearchTextChanged colapsam em 1 submit (debounce)', () async {
    when(() => repo.search('matrix')).thenAnswer(
      (_) async => const [Movie(id: 'tt0133093', title: 'The Matrix', year: '1999', poster: 'p')],
    );

    final bloc = SearchBloc(repo);

    // Captura apenas os estados relevantes (ignora SearchIdle intermediário).
    final futureStates = bloc.stream.where((s) => s is! SearchIdle).take(2).toList();

    bloc.add(SearchTextChanged('m'));
    await Future.delayed(const Duration(milliseconds: 100));
    bloc.add(SearchTextChanged('ma'));
    await Future.delayed(const Duration(milliseconds: 100));
    bloc.add(SearchTextChanged('matrix'));

    final states = await futureStates.timeout(
      const Duration(milliseconds: 900),
    ); // 400ms debounce + folga

    expect(states[0], isA<SearchLoading>());
    expect(states[1], isA<SearchSuccess>().having((s) => s.results.length, 'len', 1));

    verify(() => repo.search('matrix')).called(1);

    await bloc.close();
  });

  test('close cancela debounce pendente (não emite nada após fechar)', () async {
    final bloc = SearchBloc(repo);
    final emitted = <SearchState>[];
    final sub = bloc.stream.listen(emitted.add);

    bloc.add(SearchTextChanged('matrix'));
    await bloc.close();
    await Future.delayed(const Duration(milliseconds: 500));

    expect(emitted, isEmpty);
    await sub.cancel();
  });
}
