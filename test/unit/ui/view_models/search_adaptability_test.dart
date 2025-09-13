import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

// Ajuste os caminhos conforme sua árvore de pastas:
import 'package:movie_searcher/ui/movies/view_models/search_adaptability/search_adaptability_bloc.dart';
import 'package:movie_searcher/ui/movies/view_models/search_adaptability/search_adaptability_event.dart';
import 'package:movie_searcher/ui/movies/view_models/search_adaptability/search_adaptability_state.dart';

void main() {
  group('SearchAdaptabilityBloc', () {
    test('estado inicial', () {
      final bloc = SearchAdaptabilityBloc();
      expect(
        bloc.state,
        const SearchAdaptabilityState(barLayout: SearchBarLayout.comfortableRow, columns: 3),
      );
      bloc.close();
    });

    blocTest<SearchAdaptabilityBloc, SearchAdaptabilityState>(
      'mapeia larguras por faixas: <450, <740, <1200, <1600, >=1600',
      build: () => SearchAdaptabilityBloc(),
      act: (bloc) {
        bloc
          ..add(WidthChanged(300)) // xs
          ..add(WidthChanged(500)) // sm
          ..add(WidthChanged(800)) // md
          ..add(WidthChanged(1300)) // lg
          ..add(WidthChanged(2000)); // xl
      },
      expect: () => const [
        SearchAdaptabilityState(barLayout: SearchBarLayout.compact, columns: 1),
        SearchAdaptabilityState(barLayout: SearchBarLayout.tightRow, columns: 2),
        SearchAdaptabilityState(barLayout: SearchBarLayout.tightRow, columns: 3),
        SearchAdaptabilityState(barLayout: SearchBarLayout.comfortableRow, columns: 4),
        SearchAdaptabilityState(barLayout: SearchBarLayout.comfortableRow, columns: 6),
      ],
    );

    blocTest<SearchAdaptabilityBloc, SearchAdaptabilityState>(
      'não emite estado repetido ao permanecer no mesmo bucket (dedupe)',
      build: () => SearchAdaptabilityBloc(),
      act: (bloc) {
        // Ambos 800 e 900 caem em tightRow + 3 colunas
        bloc
          ..add(WidthChanged(800))
          ..add(WidthChanged(900));
      },
      expect: () => const [
        SearchAdaptabilityState(barLayout: SearchBarLayout.tightRow, columns: 3),
        // (nada depois, pois 900 mapeia para o mesmo estado)
      ],
    );

    blocTest<SearchAdaptabilityBloc, SearchAdaptabilityState>(
      'valida limites exatos: 450, 740, 1200, 1600',
      build: () => SearchAdaptabilityBloc(),
      act: (bloc) {
        bloc
          ..add(WidthChanged(450)) // == 450  -> tightRow, 2
          ..add(WidthChanged(740)) // == 740  -> tightRow, 3
          ..add(WidthChanged(1200)) // == 1200 -> comfortableRow, 4
          ..add(WidthChanged(1600)); // == 1600 -> comfortableRow, 6
      },
      expect: () => const [
        SearchAdaptabilityState(barLayout: SearchBarLayout.tightRow, columns: 2),
        SearchAdaptabilityState(barLayout: SearchBarLayout.tightRow, columns: 3),
        SearchAdaptabilityState(barLayout: SearchBarLayout.comfortableRow, columns: 4),
        SearchAdaptabilityState(barLayout: SearchBarLayout.comfortableRow, columns: 6),
      ],
    );

    blocTest<SearchAdaptabilityBloc, SearchAdaptabilityState>(
      'zero (ou largura negativa) cai em compact + 1 coluna',
      build: () => SearchAdaptabilityBloc(),
      act: (bloc) {
        bloc
          ..add(WidthChanged(0))
          ..add(WidthChanged(-10));
      },
      expect: () => const [
        SearchAdaptabilityState(barLayout: SearchBarLayout.compact, columns: 1),
        // -10 mapeia para o mesmo estado; não deve emitir novamente
      ],
    );
  });
}
