import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_searcher/ui/movies/view_models/recent/recent_cubit.dart';
import 'package:movie_searcher/ui/movies/view_models/recent/recent_state.dart';
import 'package:movie_searcher/data/services/local_store_service.dart';

class MockLocalStoreService extends Mock implements LocalStoreService {}

void main() {
  late LocalStoreService local;

  setUp(() {
    local = MockLocalStoreService();
  });

  blocTest<RecentCubit, RecentState>(
    'lista vazia -> RecentEmpty',
    build: () {
      when(() => local.getRecents()).thenAnswer((_) async => <String>[]);
      return RecentCubit(local);
    },
    act: (cubit) => cubit.load(),
    expect: () => [const RecentLoading(), const RecentEmpty()],
  );

  blocTest<RecentCubit, RecentState>(
    'lista com linhas malformadas -> Empty (robusto)',
    build: () {
      when(() => local.getRecents()).thenAnswer((_) async => ['tt1|onlyTwoParts', '||', '']);
      return RecentCubit(local);
    },
    act: (cubit) => cubit.load(),
    expect: () => [const RecentLoading(), const RecentEmpty()],
  );

  blocTest<RecentCubit, RecentState>(
    'lista populada válida -> RecentLoaded',
    build: () {
      when(
        () => local.getRecents(),
      ).thenAnswer((_) async => ['tt1|A|2000|https://img/a.jpg', 'tt2|B|2001|https://img/b.jpg']);
      return RecentCubit(local);
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      const RecentLoading(),
      isA<RecentLoaded>().having((s) => s.items.length, 'len', 2),
    ],
  );

  blocTest<RecentCubit, RecentState>(
    'clear chama clearAll e emite RecentEmpty',
    build: () {
      when(() => local.clearAll()).thenAnswer((_) async {});
      return RecentCubit(local);
    },
    act: (cubit) => cubit.clear(),
    expect: () => [const RecentEmpty()],
    verify: (_) => verify(() => local.clearAll()).called(1),
  );
}
