import 'package:movie_searcher/domain/models/movie.dart';

sealed class SearchState {
  final String query;
  const SearchState(this.query);
}

class SearchIdle extends SearchState {
  const SearchIdle([super.query = '']);
}

class SearchLoading extends SearchState {
  const SearchLoading(super.query);
}

class SearchSuccess extends SearchState {
  final List<Movie> results;
  const SearchSuccess(super.query, this.results);
}

class SearchEmpty extends SearchState {
  const SearchEmpty(super.query);
}

class SearchError extends SearchState {
  final String message;
  const SearchError(super.query, this.message);
}
