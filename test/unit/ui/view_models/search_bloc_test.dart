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

  setUp(() => repo = MockMoviesRepository());

  test('estado inicial é SearchIdle', () {
    final bloc = SearchBloc(repo);
    expect(bloc.state, const SearchIdle());
    bloc.close();
  });

  blocTest<SearchBloc, SearchState>(
    'SearchSubmitted vazio -> Idle',
    build: () => SearchBloc(repo),
    act: (bloc) => bloc.add(SearchSubmitted('   ')),
    expect: () => [const SearchIdle()],
  );

  blocTest<SearchBloc, SearchState>(
    'SearchSubmitted ok: Loading -> Success',
    build: () {
      when(() => repo.search('matrix')).thenAnswer(
        (_) async => [const Movie(id: 'tt0133093', title: 'The Matrix', year: '1999', poster: 'p')],
      );
      return SearchBloc(repo);
    },
    act: (bloc) => bloc.add(SearchSubmitted('matrix')),
    expect: () => [
      const SearchLoading(),
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
    expect: () => [const SearchLoading(), isA<SearchError>()],
  );

  blocTest<SearchBloc, SearchState>(
    'múltiplos SearchTextChanged colapsam em 1 submit (debounce)',
    build: () {
      when(() => repo.search('matrix')).thenAnswer(
        (_) async => [const Movie(id: 'tt0133093', title: 'The Matrix', year: '1999', poster: 'p')],
      );
      return SearchBloc(repo);
    },
    act: (bloc) async {
      bloc.add(SearchTextChanged('m'));
      await Future.delayed(const Duration(milliseconds: 100));
      bloc.add(SearchTextChanged('ma'));
      await Future.delayed(const Duration(milliseconds: 100));
      bloc.add(SearchTextChanged('matrix'));
    },
    wait: const Duration(milliseconds: 450),
    expect: () => [
      const SearchLoading(),
      isA<SearchSuccess>().having((s) => s.results.length, 'len', 1),
    ],
    verify: (_) => verify(() => repo.search('matrix')).called(1),
  );

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
