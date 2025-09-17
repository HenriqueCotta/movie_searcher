import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_searcher/data/repositories/movies_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final MoviesRepository moviesRepository;
  Timer? _debounce;
  bool _closing = false;

  SearchBloc(this.moviesRepository) : super(const SearchIdle()) {
    on<SearchTextChanged>(_onChanged);
    on<SearchSubmitted>(_onSubmitted);
    on<SearchCleared>(_onCleared);
  }

  void _emitWithQuery(Emitter<SearchState> emit, String q) {
    final s = state;
    switch (s) {
      case SearchIdle():
        emit(SearchIdle(q));
      case SearchLoading():
        emit(SearchLoading(q));
      case SearchEmpty():
        emit(SearchEmpty(q));
      case SearchError(message: final m):
        emit(SearchError(q, m));
      case SearchSuccess(results: final r):
        emit(SearchSuccess(q, r));
    }
  }

  void _onChanged(SearchTextChanged event, Emitter<SearchState> emit) {
    if (_closing) return;
    final q = event.query;

    _emitWithQuery(emit, q);

    _debounce?.cancel();
    if (q.trim().isEmpty) return;
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (_closing || isClosed) return;
      add(SearchSubmitted(q));
    });
  }

  Future<void> _onSubmitted(SearchSubmitted event, Emitter<SearchState> emit) async {
    final q = event.query.trim();
    if (q.isEmpty) {
      emit(const SearchIdle(''));
      return;
    }
    emit(SearchLoading(q));
    try {
      final results = await moviesRepository.search(q);
      if (results.isEmpty) {
        emit(SearchEmpty(q));
      } else {
        emit(SearchSuccess(q, results));
      }
    } catch (err) {
      emit(SearchError(q, err.toString()));
    }
  }

  void _onCleared(SearchCleared event, Emitter<SearchState> emit) {
    _debounce?.cancel();
    emit(const SearchIdle(''));
  }

  @override
  Future<void> close() {
    _closing = true;
    _debounce?.cancel();
    _debounce = null;
    return super.close();
  }
}
