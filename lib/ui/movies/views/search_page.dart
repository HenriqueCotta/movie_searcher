// ui/movies/views/search_page.dart
import 'package:flutter/material.dart';
import 'package:movie_searcher/ui/core/layout/breakpoints_rules.dart';
import 'package:movie_searcher/ui/core/widgets/theme_toggle_action.dart';
import 'package:movie_searcher/ui/movies/widgets/search_page/result_sliver.dart';
import 'package:movie_searcher/ui/movies/widgets/search_page/search_bar_area.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cols = movieGridColumns(context.layoutBreakPoint);

    return Scaffold(
      appBar: AppBar(title: const Text('Movie Searcher'), actions: const [ThemeToggleAction()]),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            sliver: SliverToBoxAdapter(
              child: SearchBarArea(onRecentTap: () => Navigator.pushNamed(context, '/recent')),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            sliver: ResultsSliver(columns: cols),
          ),
        ],
      ),
    );
  }
}
