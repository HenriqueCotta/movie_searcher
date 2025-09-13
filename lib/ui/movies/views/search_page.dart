import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_searcher/ui/movies/view_models/search/search_bloc.dart';
import 'package:movie_searcher/ui/movies/view_models/search/search_event.dart';
import 'package:movie_searcher/ui/movies/view_models/search/search_state.dart';
import 'package:movie_searcher/ui/movies/widgets/movie_card.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar filmes'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/recent'),
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchTxtCtrl,
                    decoration: const InputDecoration(labelText: 'Digite o título'),
                    onChanged: (t) => bloc.add(SearchTextChanged(t)),
                    onSubmitted: (t) => bloc.add(SearchSubmitted(t)),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => bloc.add(SearchSubmitted(searchTxtCtrl.text)),
                  child: const Text('Buscar'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  switch (state) {
                    case SearchLoading():
                      return const Center(child: CircularProgressIndicator());
                    case SearchEmpty():
                      return const Center(child: Text('Nenhum resultado.'));
                    case SearchError(:final message):
                      return Center(child: Text('Erro: $message'));
                    case SearchSuccess(:final results):
                      return ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (_, i) => MovieCard(movie: results[i]),
                      );
                    case SearchIdle():
                      return const Center(child: Text('Busque um filme pelo título.'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
