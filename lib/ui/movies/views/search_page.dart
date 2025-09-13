// ui/movies/views/search_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_searcher/ui/core/widgets/theme_toggle_action.dart';
import 'package:movie_searcher/ui/movies/view_models/search/search_bloc.dart';
import 'package:movie_searcher/ui/movies/view_models/search/search_event.dart';
import 'package:movie_searcher/ui/movies/view_models/search_adaptability/search_adaptability_bloc.dart';
import 'package:movie_searcher/ui/movies/view_models/search_adaptability/search_adaptability_event.dart';
import 'package:movie_searcher/ui/movies/view_models/search_adaptability/search_adaptability_state.dart';
import 'package:movie_searcher/ui/movies/widgets/search_page/result_sliver.dart';
import 'package:movie_searcher/ui/movies/widgets/search_page/search_bar_area.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchTxtCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SearchBloc>();

    return LayoutBuilder(
      builder: (ctx, c) {
        // informa largura atual ao BLoC de adaptabilidade (UI-only)
        ctx.read<SearchAdaptabilityBloc>().add(WidthChanged(c.maxWidth));

        return Scaffold(
          appBar: AppBar(title: const Text('Movie Searcher'), actions: const [ThemeToggleAction()]),
          body: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                sliver: SliverToBoxAdapter(
                  child: SearchBarArea(
                    controller: searchTxtCtrl,
                    onChanged: (t) => bloc.add(SearchTextChanged(t)),
                    onSubmit: () => bloc.add(SearchSubmitted(searchTxtCtrl.text)),
                    onRecentTap: () => Navigator.pushNamed(context, '/recent'),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                sliver: BlocBuilder<SearchAdaptabilityBloc, SearchAdaptabilityState>(
                  builder: (context, state) {
                    return ResultsSliver(columns: state.columns);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
