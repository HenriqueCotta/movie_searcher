// ui/movies/view_models/search/search_state.dart
import 'package:movie_searcher/domain/models/movie.dart';

sealed class SearchState {
  const SearchState();
}

class SearchIdle extends SearchState {
  const SearchIdle();
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchSuccess extends SearchState {
  final List<Movie> results;
  const SearchSuccess(this.results);
}

class SearchEmpty extends SearchState {
  const SearchEmpty();
}

class SearchError extends SearchState {
  final String message;
  const SearchError(this.message);
}
