import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers.dart';
import 'package:movie_searcher/data/repositories/movies_repository.dart';
import 'package:movie_searcher/data/services/local_store_service.dart';
import 'package:movie_searcher/domain/models/movie.dart';

class MockMoviesRepository extends Mock implements MoviesRepository {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Fluxo completo: busca -> detalhe -> recentes', () {
    testWidgets('mostra resultados, abre detalhe e persiste em Recentes', (tester) async {
      // prefs em memória
      SharedPreferences.setMockInitialValues({});

      // Mock do repositório
      final repo = MockMoviesRepository();
      when(() => repo.search('matrix')).thenAnswer(
        (_) async => const [
          Movie(id: 'tt1', title: 'The Matrix', year: '1999', poster: 'https://img/p.jpg'),
        ],
      );
      when(() => repo.getById('tt1')).thenAnswer(
        (_) async => const Movie(
          id: 'tt1',
          title: 'The Matrix',
          year: '1999',
          poster: 'https://img/p.jpg',
          genre: 'Action, Sci-Fi',
          plot: 'Long plot...',
        ),
      );

      final store = LocalStoreService();

      await tester.pumpWidget(buildTestApp(repo: repo, store: store));
      await tester.pumpAndSettle();

      // Busca
      expect(find.text('Busque um filme pelo título.'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'matrix');
      await tester.tap(find.text('Buscar'));
      await tester.pumpAndSettle();

      // Lista com o item mockado
      expect(find.text('The Matrix'), findsOneWidget);

      // Abre detalhe
      await tester.tap(find.text('The Matrix'));
      await tester.pumpAndSettle();

      // DetailPage renderizada com dados "completos"
      expect(find.text('Detalhes'), findsOneWidget);
      expect(find.text('The Matrix'), findsOneWidget);
      expect(find.text('1999'), findsOneWidget);
      expect(find.text('Action, Sci-Fi'), findsOneWidget);
      expect(find.text('Long plot...'), findsOneWidget);

      // Volta e abre Recentes
      await tester.pageBack();
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.history));
      await tester.pumpAndSettle();

      expect(find.text('Recentes'), findsOneWidget);
      expect(find.text('The Matrix'), findsOneWidget);
    });
  });
}
