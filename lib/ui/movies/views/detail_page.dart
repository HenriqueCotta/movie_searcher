import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_searcher/ui/movies/view_models/detail/detail_cubit.dart';
import 'package:movie_searcher/ui/movies/view_models/detail/detail_state.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final id = ModalRoute.of(context)!.settings.arguments as String;
    context.read<DetailCubit>().load(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes')),
      body: BlocBuilder<DetailCubit, DetailState>(
        builder: (_, state) {
          if (state is DetailLoading) return const Center(child: CircularProgressIndicator());
          if (state is DetailError) return Center(child: Text('Erro: ${state.message}'));
          final m = (state as DetailLoaded).movie;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    m.poster,
                    height: 300,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, size: 120),
                  ),
                ),
                const SizedBox(height: 16),
                Text(m.title, style: Theme.of(context).textTheme.headlineSmall),
                Text(m.year),
                const SizedBox(height: 8),
                Text(m.genre, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 12),
                Text(m.plot),
              ],
            ),
          );
        },
      ),
    );
  }
}
