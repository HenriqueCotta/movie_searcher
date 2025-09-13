// ui/movies/widgets/search_page/search_bar/search_bar_area.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_searcher/ui/movies/view_models/search_adaptability/search_adaptability_state.dart';
import 'package:movie_searcher/ui/movies/view_models/search_adaptability/search_adaptability_bloc.dart';

class SearchBarArea extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;
  final VoidCallback onRecentTap;

  const SearchBarArea({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onSubmit,
    required this.onRecentTap,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.select<SearchAdaptabilityBloc, SearchBarLayout>(
      (b) => b.state.barLayout,
    );

    return switch (layout) {
      SearchBarLayout.compact => _CompactLayout(
        controller: controller,
        onChanged: onChanged,
        onSubmit: onSubmit,
        onRecentTap: onRecentTap,
      ),
      SearchBarLayout.tightRow => _TightRowLayout(
        controller: controller,
        onChanged: onChanged,
        onSubmit: onSubmit,
        onRecentTap: onRecentTap,
      ),
      SearchBarLayout.comfortableRow => _ComfortableRowLayout(
        controller: controller,
        onChanged: onChanged,
        onSubmit: onSubmit,
        onRecentTap: onRecentTap,
      ),
    };
  }
}

/// ---------- peças reutilizáveis ----------
class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;
  const _SearchField({required this.controller, required this.onChanged, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (_, v, __) {
        final hasText = v.text.isNotEmpty;
        return TextField(
          controller: controller,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Buscar por título',
            prefixIcon: Icon(Icons.search, color: cs.onSurfaceVariant),
            suffixIcon: hasText
                ? IconButton(
                    tooltip: 'Limpar',
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      controller.clear();
                      onChanged('');
                    },
                  )
                : null,
          ),
          onChanged: onChanged,
          onSubmitted: (_) {
            FocusScope.of(context).unfocus();
            onSubmit();
          },
          maxLines: 1,
        );
      },
    );
  }
}

/// ---------- layouts (iguais aos que você já tinha) ----------
class _CompactLayout extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;
  final VoidCallback onRecentTap;
  const _CompactLayout({
    required this.controller,
    required this.onChanged,
    required this.onSubmit,
    required this.onRecentTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _SearchField(controller: controller, onChanged: onChanged, onSubmit: onSubmit),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: FilledButton.icon(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        onSubmit();
                      },
                      icon: const Icon(Icons.search),
                      label: const Text('Buscar'),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: onRecentTap,
                      icon: const Icon(Icons.history),
                      label: const Text('Recentes'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TightRowLayout extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;
  final VoidCallback onRecentTap;
  const _TightRowLayout({
    required this.controller,
    required this.onChanged,
    required this.onSubmit,
    required this.onRecentTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: _SearchField(controller: controller, onChanged: onChanged, onSubmit: onSubmit),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 48,
              width: 48,
              child: IconButton.filled(
                tooltip: 'Buscar',
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  onSubmit();
                },
                icon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(width: 4),
            SizedBox(
              height: 48,
              width: 48,
              child: IconButton(
                tooltip: 'Recentes',
                onPressed: onRecentTap,
                icon: const Icon(Icons.history),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComfortableRowLayout extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;
  final VoidCallback onRecentTap;
  const _ComfortableRowLayout({
    required this.controller,
    required this.onChanged,
    required this.onSubmit,
    required this.onRecentTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: _SearchField(controller: controller, onChanged: onChanged, onSubmit: onSubmit),
            ),
            const SizedBox(width: 12),
            SizedBox(
              height: 48,
              child: FilledButton.icon(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  onSubmit();
                },
                icon: const Icon(Icons.search),
                label: const Text('Buscar'),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: 'Recentes',
              onPressed: onRecentTap,
              icon: const Icon(Icons.history),
            ),
          ],
        ),
      ),
    );
  }
}
