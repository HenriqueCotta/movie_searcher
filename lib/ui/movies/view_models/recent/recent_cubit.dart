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

      final items = <Movie>[];
      for (final r in rows) {
        final p = r.split('|');
        if (p.length >= 4 && p[0].isNotEmpty) {
          items.add(Movie(id: p[0], title: p[1], year: p[2], poster: p[3]));
        }
      }

      if (items.isEmpty) {
        emit(const RecentEmpty());
      } else {
        emit(RecentLoaded(items));
      }
    } catch (e) {
      emit(RecentError(e.toString()));
    }
  }

  Future<void> clear() async {
    await local.clearAll();
    emit(const RecentEmpty());
  }
}
