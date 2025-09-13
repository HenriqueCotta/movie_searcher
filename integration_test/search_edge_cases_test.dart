import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers.dart';
import 'package:movie_searcher/data/repositories/movies_repository.dart';
import 'package:movie_searcher/data/services/local_store_service.dart';

class MockMoviesRepository extends Mock implements MoviesRepository {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('lista vazia -> "Nenhum resultado."', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final repo = MockMoviesRepository();
    when(() => repo.search('nada')).thenAnswer((_) async => []);
    final store = LocalStoreService();

    await tester.pumpWidget(buildTestApp(repo: repo, store: store));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'nada');
    await tester.tap(find.text('Buscar'));
    await tester.pumpAndSettle();

    expect(find.text('Nenhum resultado.'), findsOneWidget);
  });

  testWidgets('erro na busca -> mostra mensagem de erro', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final repo = MockMoviesRepository();
    when(() => repo.search('boom')).thenThrow(Exception('falhou'));
    final store = LocalStoreService();

    await tester.pumpWidget(buildTestApp(repo: repo, store: store));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'boom');
    await tester.tap(find.text('Buscar'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Erro:'), findsOneWidget);
    expect(find.textContaining('falhou'), findsOneWidget);
  });

  testWidgets('query vazia mantém estado Idle', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final repo = MockMoviesRepository();
    final store = LocalStoreService();

    await tester.pumpWidget(buildTestApp(repo: repo, store: store));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '   ');
    await tester.tap(find.text('Buscar'));
    await tester.pumpAndSettle();

    expect(find.text('Busque um filme pelo título.'), findsOneWidget);
  });
}
