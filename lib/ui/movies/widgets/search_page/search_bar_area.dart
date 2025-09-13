// ui/movies/widgets/search_page/search_bar/search_bar_area.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_searcher/ui/core/layout/breakpoints_rules.dart';
import 'package:movie_searcher/ui/movies/view_models/search/search_bloc.dart';
import 'package:movie_searcher/ui/movies/view_models/search/search_event.dart';
import 'package:movie_searcher/ui/movies/view_models/search/search_state.dart';

enum SearchBarLayout { compact, tightRow, comfortableRow }

class SearchBarArea extends StatefulWidget {
  final VoidCallback onRecentTap;
  const SearchBarArea({super.key, required this.onRecentTap});

  @override
  State<SearchBarArea> createState() => _SearchBarAreaState();
}

class _SearchBarAreaState extends State<SearchBarArea> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  SearchBarLayout _layoutFor(Breakpoint bp) {
    if (bp == Breakpoint.xs) return SearchBarLayout.compact;
    if (bp == Breakpoint.sm || bp == Breakpoint.md) return SearchBarLayout.tightRow;
    return SearchBarLayout.comfortableRow;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SearchBloc>();

    return BlocBuilder<SearchBloc, SearchState>(
      buildWhen: (p, n) => p.query != n.query, // rebuild só quando o texto muda
      builder: (context, state) {
        // mantém controller sincronizado com o estado
        if (_ctrl.text != state.query) {
          _ctrl.value = TextEditingValue(
            text: state.query,
            selection: TextSelection.collapsed(offset: state.query.length),
          );
        }

        final hasText = state.query.isNotEmpty;
        final layout = _layoutFor(context.layoutBreakPoint);

        void onSubmit() {
          FocusScope.of(context).unfocus();
          bloc.add(SearchSubmitted(_ctrl.text));
        }

        void onChanged(String v) => bloc.add(SearchTextChanged(v));
        void onClear() => bloc.add(SearchCleared());

        return switch (layout) {
          SearchBarLayout.compact => _Compact(
            ctrl: _ctrl,
            hasText: hasText,
            onChanged: onChanged,
            onSubmit: onSubmit,
            onClear: onClear,
            onRecentTap: widget.onRecentTap,
          ),
          SearchBarLayout.tightRow => _TightRow(
            ctrl: _ctrl,
            hasText: hasText,
            onChanged: onChanged,
            onSubmit: onSubmit,
            onClear: onClear,
            onRecentTap: widget.onRecentTap,
          ),
          SearchBarLayout.comfortableRow => _ComfortableRow(
            ctrl: _ctrl,
            hasText: hasText,
            onChanged: onChanged,
            onSubmit: onSubmit,
            onClear: onClear,
            onRecentTap: widget.onRecentTap,
          ),
        };
      },
    );
  }
}

// ---------- peças ----------
class _SearchField extends StatelessWidget {
  final TextEditingController ctrl;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;
  final bool hasText;
  final VoidCallback onClear;

  const _SearchField({
    required this.ctrl,
    required this.onChanged,
    required this.onSubmit,
    required this.hasText,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TextField(
      controller: ctrl,
      textInputAction: TextInputAction.search,
      maxLines: 1,
      decoration: InputDecoration(
        hintText: 'Buscar por título',
        prefixIcon: Icon(Icons.search, color: cs.onSurfaceVariant),
        suffixIcon: hasText
            ? IconButton(tooltip: 'Limpar', icon: const Icon(Icons.clear), onPressed: onClear)
            : null,
      ),
      onChanged: onChanged,
      onSubmitted: (_) => onSubmit(),
    );
  }
}

// ---------- layouts ----------
class _Compact extends StatelessWidget {
  final TextEditingController ctrl;
  final bool hasText;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit, onClear, onRecentTap;

  const _Compact({
    required this.ctrl,
    required this.hasText,
    required this.onChanged,
    required this.onSubmit,
    required this.onClear,
    required this.onRecentTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _SearchField(
              ctrl: ctrl,
              onChanged: onChanged,
              onSubmit: onSubmit,
              hasText: hasText,
              onClear: onClear,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: FilledButton.icon(
                      onPressed: onSubmit,
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

class _TightRow extends StatelessWidget {
  final TextEditingController ctrl;
  final bool hasText;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit, onClear, onRecentTap;

  const _TightRow({
    required this.ctrl,
    required this.hasText,
    required this.onChanged,
    required this.onSubmit,
    required this.onClear,
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
              child: _SearchField(
                ctrl: ctrl,
                onChanged: onChanged,
                onSubmit: onSubmit,
                hasText: hasText,
                onClear: onClear,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 48,
              width: 48,
              child: IconButton.filled(
                tooltip: 'Buscar',
                onPressed: onSubmit,
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

class _ComfortableRow extends StatelessWidget {
  final TextEditingController ctrl;
  final bool hasText;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit, onClear, onRecentTap;

  const _ComfortableRow({
    required this.ctrl,
    required this.hasText,
    required this.onChanged,
    required this.onSubmit,
    required this.onClear,
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
              child: _SearchField(
                ctrl: ctrl,
                onChanged: onChanged,
                onSubmit: onSubmit,
                hasText: hasText,
                onClear: onClear,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              height: 48,
              child: FilledButton.icon(
                onPressed: onSubmit,
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
