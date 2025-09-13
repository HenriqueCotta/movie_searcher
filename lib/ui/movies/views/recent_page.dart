import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_searcher/ui/core/widgets/theme_toggle_action.dart';
import 'package:movie_searcher/ui/movies/view_models/recent/recent_cubit.dart';
import 'package:movie_searcher/ui/movies/view_models/recent/recent_state.dart';
import 'package:movie_searcher/ui/movies/widgets/movie_card.dart';
import 'package:movie_searcher/ui/movies/widgets/movie_grid_title.dart';

int _cols(double w) {
  if (w >= 1200) return 6;
  if (w >= 840) return 4;
  if (w >= 600) return 2;
  return 1;
}

class RecentPage extends StatefulWidget {
  const RecentPage({super.key});
  @override
  State<RecentPage> createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<RecentCubit>().load());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cols = _cols(size.width);

    return Scaffold(
      appBar: AppBar(title: const Text('Recentes'), actions: const [ThemeToggleAction()]),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: BlocBuilder<RecentCubit, RecentState>(
          builder: (_, state) {
            if (state is RecentLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is RecentEmpty) {
              return const _Empty();
            }
            if (state is RecentError) {
              return Center(child: Text('Erro: ${state.message}'));
            }
            final items = (state as RecentLoaded).items;

            if (cols == 1) {
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, i) => MovieCard(movie: items[i]),
              );
            }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2 / 3 + 0.15,
              ),
              itemCount: items.length,
              itemBuilder: (_, i) => MovieGridTile(movie: items[i]),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.read<RecentCubit>().clear(),
        icon: const Icon(Icons.delete_sweep_outlined),
        label: const Text('Limpar'),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.history, size: 56, color: cs.outline),
          const SizedBox(height: 12),
          const Text('Sem filmes recentes.'),
        ],
      ),
    );
  }
}
