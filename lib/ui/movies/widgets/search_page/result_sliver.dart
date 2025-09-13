// ui/movies/widgets/search_page/result_sliver.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_searcher/ui/movies/view_models/search/search_bloc.dart';
import 'package:movie_searcher/ui/movies/view_models/search/search_state.dart';
import 'package:movie_searcher/ui/movies/widgets/movie_card.dart';
import 'package:movie_searcher/ui/movies/widgets/movie_grid_title.dart';
import 'package:movie_searcher/ui/movies/widgets/search_page/states_sliver.dart';

class ResultsSliver extends StatelessWidget {
  final int columns;
  const ResultsSliver({super.key, required this.columns});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return switch (state) {
          SearchLoading() => const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          ),
          SearchEmpty() => const EmptyStateSliver(
            icon: Icons.search_off,
            message: 'Nenhum resultado.',
          ),
          SearchError(message: final m) => ErrorStateSliver(message: m),
          SearchSuccess(results: final list) =>
            columns == 1
                ? SliverList.builder(
                    itemCount: list.length,
                    itemBuilder: (_, i) => MovieCard(movie: list[i]),
                  )
                : SliverGrid.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 2 / 3 + 0.15,
                    ),
                    itemCount: list.length,
                    itemBuilder: (_, i) => MovieGridTile(movie: list[i]),
                  ),
          SearchIdle() => const EmptyStateSliver(
            icon: Icons.local_movies_outlined,
            message: 'Busque um filme pelo título.',
          ),
        };
      },
    );
  }
}
