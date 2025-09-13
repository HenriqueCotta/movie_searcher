import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_searcher/ui/movies/view_models/recent/recent_cubit.dart';
import 'package:movie_searcher/ui/movies/view_models/recent/recent_state.dart';
import 'package:movie_searcher/ui/movies/widgets/movie_card.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('Recentes')),
      body: BlocBuilder<RecentCubit, RecentState>(
        builder: (_, state) {
          if (state is RecentLoading) return const Center(child: CircularProgressIndicator());
          if (state is RecentEmpty) return const Center(child: Text('Sem filmes recentes.'));
          if (state is RecentError) return Center(child: Text('Erro: ${state.message}'));
          final items = (state as RecentLoaded).items;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, i) => MovieCard(movie: items[i]),
          );
        },
      ),
    );
  }
}
