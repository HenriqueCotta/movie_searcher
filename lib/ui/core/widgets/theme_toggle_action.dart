import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_searcher/ui/core/theme/theme_cubit.dart';

class ThemeToggleAction extends StatelessWidget {
  const ThemeToggleAction({super.key});

  @override
  Widget build(BuildContext context) {
    final mode = context.watch<ThemeCubit>().state;
    final icon = switch (mode) {
      ThemeMode.light => Icons.light_mode,
      ThemeMode.dark => Icons.dark_mode,
      ThemeMode.system => Icons.brightness_auto,
    };
    final tooltip =
        'Tema: ${switch (mode) {
          ThemeMode.light => 'Claro',
          ThemeMode.dark => 'Escuro',
          ThemeMode.system => 'Automático',
        }} (toque p/ alternar)';

    return IconButton(
      tooltip: tooltip,
      icon: Icon(icon),
      onPressed: () => context.read<ThemeCubit>().toggle(),
    );
  }
}
