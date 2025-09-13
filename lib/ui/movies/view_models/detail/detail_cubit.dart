import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_searcher/data/repositories/movies_repository.dart';
import 'package:movie_searcher/data/services/local_store_service.dart';
import 'detail_state.dart';

class DetailCubit extends Cubit<DetailState> {
  final MoviesRepository repo;
  final LocalStoreService local;
  DetailCubit(this.repo, this.local) : super(const DetailLoading());

  Future<void> load(String id) async {
    emit(const DetailLoading());
    try {
      final m = await repo.getById(id);
      final row = '${m.id}|${m.title}|${m.year}|${m.poster}';
      await local.saveRecent(row);
      emit(DetailLoaded(m));
    } catch (e) {
      emit(DetailError(e.toString()));
    }
  }
}
