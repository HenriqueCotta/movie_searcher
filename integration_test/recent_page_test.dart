import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers.dart';
import 'package:movie_searcher/data/repositories/movies_repository.dart';
import 'package:movie_searcher/data/services/local_store_service.dart';

class DummyRepo extends Mock implements MoviesRepository {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Recentes vazio ao abrir rota direta', (tester) async {
    SharedPreferences.setMockInitialValues({});

    final repo = DummyRepo(); // não é usado nesta tela
    final store = LocalStoreService();

    await tester.pumpWidget(buildTestApp(repo: repo, store: store, initialRoute: '/recent'));
    await tester.pumpAndSettle();

    expect(find.text('Recentes'), findsOneWidget);
    expect(find.text('Sem filmes recentes.'), findsOneWidget);
  });
}
