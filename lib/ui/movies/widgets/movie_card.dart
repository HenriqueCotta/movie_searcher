import 'package:flutter/material.dart';
import 'package:movie_searcher/domain/models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        movie.poster,
        width: 50,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
      ),
      title: Text(movie.title),
      subtitle: Text(movie.year),
      onTap: () => Navigator.pushNamed(context, '/detail', arguments: movie.id),
    );
  }
}
