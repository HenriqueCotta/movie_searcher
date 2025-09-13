import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_searcher/data/repositories/movies_repository.dart';
import 'package:movie_searcher/data/services/dio_service.dart';
import 'package:movie_searcher/data/services/local_store_service.dart';
import 'package:movie_searcher/data/services/movie_service.dart';
import 'package:movie_searcher/ui/core/theme/app_theme.dart';
import 'package:movie_searcher/ui/core/theme/theme_cubit.dart';
import 'package:movie_searcher/ui/movies/view_models/detail/detail_cubit.dart';
import 'package:movie_searcher/ui/movies/view_models/recent/recent_cubit.dart';
import 'package:movie_searcher/ui/movies/view_models/search/search_bloc.dart';
import 'package:movie_searcher/ui/movies/views/detail_page.dart';
import 'package:movie_searcher/ui/movies/views/recent_page.dart';
import 'package:movie_searcher/ui/movies/views/search_page.dart';

Widget buildApp() {
  const baseUrl = String.fromEnvironment('OMDB_BASE_URL', defaultValue: 'https://www.omdbapi.com/');
  const apiKey = String.fromEnvironment('OMDB_API_KEY', defaultValue: 'SUA_CHAVE');

  final dio = DioService(baseUrl);
  final movieSvc = MovieService(dio, apiKey: apiKey);
  final localStore = LocalStoreService();
  final moviesRepo = MoviesRepository(movieSvc);

  return MultiRepositoryProvider(
    providers: [
      RepositoryProvider.value(value: moviesRepo),
      RepositoryProvider.value(value: localStore),
    ],
    child: BlocProvider(
      create: (_) => ThemeCubit()..load(),
      child: Builder(
        builder: (context) {
          final mode = context.watch<ThemeCubit>().state;
          return MaterialApp(
            title: 'Movies',
            debugShowCheckedModeBanner: false,
            theme: buildLightTheme(),
            darkTheme: buildDarkTheme(),
            themeMode: mode,
            initialRoute: '/',
            routes: {
              '/': (ctx) => BlocProvider(
                create: (_) => SearchBloc(ctx.read<MoviesRepository>()),
                child: const SearchPage(),
              ),
              '/detail': (ctx) => BlocProvider(
                create: (_) =>
                    DetailCubit(ctx.read<MoviesRepository>(), ctx.read<LocalStoreService>()),
                child: const DetailPage(),
              ),
              '/recent': (ctx) => BlocProvider(
                create: (_) => RecentCubit(ctx.read<LocalStoreService>())..load(),
                child: const RecentPage(),
              ),
            },
          );
        },
      ),
    ),
  );
}
