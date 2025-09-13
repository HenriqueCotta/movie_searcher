// ui/movies/view_models/recent/recent_state.dart
import 'package:movie_searcher/domain/models/movie.dart';

sealed class RecentState {
  const RecentState();
}

class RecentLoading extends RecentState {
  const RecentLoading();
}

class RecentLoaded extends RecentState {
  final List<Movie> items;
  const RecentLoaded(this.items);
}

class RecentEmpty extends RecentState {
  const RecentEmpty();
}

class RecentError extends RecentState {
  final String message;
  const RecentError(this.message);
}
