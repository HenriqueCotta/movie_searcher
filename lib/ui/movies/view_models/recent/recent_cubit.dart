// ui/movies/view_models/recent/recent_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_searcher/data/services/local_store_service.dart';
import 'package:movie_searcher/domain/models/movie.dart';
import 'recent_state.dart';

class RecentCubit extends Cubit<RecentState> {
  final LocalStoreService local;
  RecentCubit(this.local) : super(const RecentLoading());

  Future<void> load() async {
    emit(const RecentLoading());
    try {
      final rows = await local.getRecents();
      if (rows.isEmpty) {
        emit(const RecentEmpty());
        return;
      }
      final items = rows.map((r) {
        final p = r.split('|'); // id|title|year|poster
        return Movie(id: p[0], title: p[1], year: p[2], poster: p[3]);
      }).toList();
      emit(RecentLoaded(items));
    } catch (e) {
      emit(RecentError(e.toString()));
    }
  }

  Future<void> clear() async {
    await local.saveRecent(''); // opcional: você pode criar método dedicado limpar
    await load();
  }
}
