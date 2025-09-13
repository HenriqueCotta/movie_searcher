import 'package:shared_preferences/shared_preferences.dart';

class LocalStoreService {
  static const _key = 'recent_movies';
  Future<void> saveRecent(String row) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    final dedup = [row, ...raw.where((e) => !e.startsWith('${row.split('|').first}|'))];
    await prefs.setStringList(_key, dedup.take(5).toList());
  }

  Future<List<String>> getRecents() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }
}
