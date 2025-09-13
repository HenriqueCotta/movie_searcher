import 'package:movie_searcher/domain/models/movie.dart';

sealed class DetailState {
  const DetailState();
}

class DetailLoading extends DetailState {
  const DetailLoading();
}

class DetailLoaded extends DetailState {
  final Movie movie;
  const DetailLoaded(this.movie);
}

class DetailError extends DetailState {
  final String message;
  const DetailError(this.message);
}
