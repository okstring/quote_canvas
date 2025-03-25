import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quote_canvas/router/app_route.dart';
import '../views/home_view.dart';
import '../views/settings_view.dart';
import '../views/favorites_view.dart';

final appRouter = GoRouter(
  initialLocation: const AppRoute.home().path,
  routes: [
    GoRoute(
      path: const AppRoute.home().path,
      name: const AppRoute.home().name,
      builder: (context, state) => const HomeView(),
    ),
    GoRoute(
      path: const AppRoute.settings().path,
      name: const AppRoute.settings().name,
      builder: (context, state) => const SettingsView(),
    ),
    GoRoute(
      path: const AppRoute.favorites().path,
      name: const AppRoute.favorites().name,
      builder: (context, state) => const FavoritesView(),
    ),
  ],
  // 에러 핸들링
  errorBuilder:
      (context, state) =>
          Scaffold(body: Center(child: Text('경로를 찾을 수 없습니다: ${state.uri}'))),
);
