import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_searcher/data/repositories/movies_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final MoviesRepository moviesRepository;
  Timer? _debounce;
  SearchBloc(this.moviesRepository) : super(const SearchIdle()) {
    on<SearchTextChanged>(_onChanged);
    on<SearchSubmitted>(_onSubmitted);
    on<SearchCleared>((_, emit) => emit(const SearchIdle()));
  }

  void _onChanged(SearchTextChanged event, Emitter<SearchState> _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      add(SearchSubmitted(event.query));
    });
  }

  Future<void> _onSubmitted(SearchSubmitted event, Emitter<SearchState> emit) async {
    final q = event.query.trim();
    if (q.isEmpty) {
      emit(const SearchIdle());
      return;
    }
    emit(const SearchLoading());
    try {
      final results = await moviesRepository.search(q);
      if (results.isEmpty) {
        emit(const SearchEmpty());
      } else {
        emit(SearchSuccess(results));
      }
    } catch (err) {
      emit(SearchError(err.toString()));
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
