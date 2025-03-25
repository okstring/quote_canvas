import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../views/home_view.dart';
import '../views/settings_view.dart';
import '../views/favorites_view.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeView(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsView(),
    ),
    GoRoute(
      path: '/favorites',
      name: 'favorites',
      builder: (context, state) => const FavoritesView(),
    ),
  ],
  // 에러 핸들링
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('경로를 찾을 수 없습니다: ${state.uri}'),
    ),
  ),
);