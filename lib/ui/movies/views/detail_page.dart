import 'dart:math' as math;
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
          if (state is DetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is DetailError) {
            return Center(child: Text('Erro: ${state.message}'));
          }

          final m = (state as DetailLoaded).movie;

          return LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 720;
              final posterWidth = isCompact ? math.min(constraints.maxWidth * 0.30, 120.0) : 180.0;

              final info = _MovieInfo(title: m.title, year: m.year, genre: m.genre, plot: m.plot);

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: isCompact
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _Poster(url: m.poster, width: posterWidth),
                              const SizedBox(width: 16),
                              Expanded(child: info.headerOnly()),
                            ],
                          ),
                          const SizedBox(height: 16),
                          info.plotOnly(),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Poster(url: m.poster, width: posterWidth),
                          const SizedBox(width: 24),
                          Expanded(child: info.full()),
                        ],
                      ),
              );
            },
          );
        },
      ),
    );
  }
}

class _Poster extends StatelessWidget {
  final String url;
  final double width;
  const _Poster({required this.url, required this.width});

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final cacheWidth = (width * dpr).round();
    final height = width * 1.5;

    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          cacheWidth: cacheWidth,
          filterQuality: FilterQuality.medium,
          errorBuilder: (_, __, ___) => Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            alignment: Alignment.center,
            child: const Icon(Icons.image_not_supported, size: 48),
          ),
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: (progress.expectedTotalBytes != null)
                    ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MovieInfo {
  final String title;
  final String year;
  final String genre;
  final String plot;
  _MovieInfo({required this.title, required this.year, required this.genre, required this.plot});

  Widget headerOnly() => Builder(
    builder: (context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 4),
        Text(year, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8),
        _GenreChips(genre: genre),
      ],
    ),
  );

  Widget plotOnly() => Builder(
    builder: (context) => Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          plot.isEmpty ? 'Sem sinopse disponível.' : plot,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    ),
  );

  Widget full() => Builder(
    builder: (context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 4),
        Text(year, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8),
        _GenreChips(genre: genre),
        const SizedBox(height: 16),
        plotOnly(),
      ],
    ),
  );
}

class _GenreChips extends StatelessWidget {
  final String genre;
  const _GenreChips({required this.genre});

  @override
  Widget build(BuildContext context) {
    final parts = genre.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final g in parts)
          Chip(
            label: Text(g),
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
      ],
    );
  }
}
