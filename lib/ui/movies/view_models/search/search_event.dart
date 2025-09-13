// ui/movies/view_models/search/search_event.dart
abstract class SearchEvent {}

class SearchTextChanged extends SearchEvent {
  final String query;
  SearchTextChanged(this.query);
}

class SearchSubmitted extends SearchEvent {
  final String query;
  SearchSubmitted(this.query);
}

class SearchCleared extends SearchEvent {}
