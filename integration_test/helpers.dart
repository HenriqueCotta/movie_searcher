// integration_test/helpers.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_searcher/data/repositories/movies_repository.dart';
import 'package:movie_searcher/data/services/local_store_service.dart';
import 'package:movie_searcher/ui/movies/view_models/detail/detail_cubit.dart';
import 'package:movie_searcher/ui/movies/view_models/recent/recent_cubit.dart';
import 'package:movie_searcher/ui/movies/view_models/search/search_bloc.dart';
import 'package:movie_searcher/ui/movies/views/detail_page.dart';
import 'package:movie_searcher/ui/movies/views/recent_page.dart';
import 'package:movie_searcher/ui/movies/views/search_page.dart';

Widget buildTestApp({
  required MoviesRepository repo,
  required LocalStoreService store,
  String initialRoute = '/',
}) {
  return MultiRepositoryProvider(
    providers: [
      RepositoryProvider<MoviesRepository>.value(value: repo),
      RepositoryProvider<LocalStoreService>.value(value: store),
    ],
    child: MaterialApp(
      title: 'Movies (integration)',
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        '/': (ctx) => BlocProvider(
          create: (_) => SearchBloc(ctx.read<MoviesRepository>()),
          child: const SearchPage(),
        ),
        '/detail': (ctx) => BlocProvider(
          create: (_) => DetailCubit(ctx.read<MoviesRepository>(), ctx.read<LocalStoreService>()),
          child: const DetailPage(),
        ),
        '/recent': (ctx) => BlocProvider(
          create: (_) => RecentCubit(ctx.read<LocalStoreService>())..load(),
          child: const RecentPage(),
        ),
      },
    ),
  );
}
