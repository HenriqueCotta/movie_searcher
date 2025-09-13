import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_adaptability_event.dart';
import 'search_adaptability_state.dart';

class SearchAdaptabilityBloc extends Bloc<SearchAdaptabilityEvent, SearchAdaptabilityState> {
  SearchAdaptabilityBloc()
    : super(const SearchAdaptabilityState(barLayout: SearchBarLayout.comfortableRow, columns: 3)) {
    on<WidthChanged>(_onWidthChanged);
  }

  // Regras de responsividade centralizadas aqui (UI-only!)
  SearchAdaptabilityState _stateForWidth(double w) {
    // você pode ajustar estes breakpoints sem tocar em widgets
    if (w < 450) {
      return const SearchAdaptabilityState(barLayout: SearchBarLayout.compact, columns: 1);
    } else if (w < 740) {
      return const SearchAdaptabilityState(barLayout: SearchBarLayout.tightRow, columns: 2);
    } else if (w < 1200) {
      return const SearchAdaptabilityState(barLayout: SearchBarLayout.tightRow, columns: 3);
    } else if (w < 1600) {
      return const SearchAdaptabilityState(barLayout: SearchBarLayout.comfortableRow, columns: 4);
    } else {
      return const SearchAdaptabilityState(barLayout: SearchBarLayout.comfortableRow, columns: 6);
    }
  }

  void _onWidthChanged(WidthChanged e, Emitter<SearchAdaptabilityState> emit) {
    final next = _stateForWidth(e.width);
    if (next != state) emit(next);
  }
}
