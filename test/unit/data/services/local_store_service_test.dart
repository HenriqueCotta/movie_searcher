import 'package:flutter_test/flutter_test.dart';
import 'package:movie_searcher/data/services/local_store_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('LocalStoreService: salva, deduplica por id e limita a 5 itens', () async {
    SharedPreferences.setMockInitialValues({});
    final store = LocalStoreService();

    await store.saveRecent('tt1|A|2000|p');
    await store.saveRecent('tt2|B|2001|p');
    await store.saveRecent('tt1|A2|2000|p2');

    var list = await store.getRecents();
    expect(list.length, 2);
    expect(list.first.startsWith('tt1|'), true);

    await store.saveRecent('tt3|C|2002|p');
    await store.saveRecent('tt4|D|2003|p');
    await store.saveRecent('tt5|E|2004|p');
    await store.saveRecent('tt6|F|2005|p');

    list = await store.getRecents();
    expect(list.length, 5);
    expect(list.first.startsWith('tt6|'), true);
  });
}
