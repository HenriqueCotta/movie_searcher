import 'package:shared_preferences/shared_preferences.dart';

class LocalStoreService {
  static const _key = 'recent_movies';
  Future<void> saveRecent(String row) async {
    if (row.trim().isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    final id = row.split('|').first;
    final dedup = [row, ...raw.where((e) => !e.startsWith('$id|'))];
    await prefs.setStringList(_key, dedup.take(5).toList());
  }

  Future<List<String>> getRecents() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
