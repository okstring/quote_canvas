import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quote_canvas/core/routing/router/routes.dart';
import 'package:quote_canvas/ui/views/home_view.dart';
import 'package:quote_canvas/ui/views/settings_view.dart';

class AppRouter {
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorHomeKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: Routes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return navigationShell;
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomeKey,
            routes: [
              GoRoute(
                path: Routes.home,
                builder: (context, state) => HomeView(),
                routes: [
                  GoRoute(
                    path: Routes.settings,
                    builder: (context, state) => const SettingsView(),
                  ),
                  GoRoute(
                    path: Routes.favorites,
                    builder: (context, state) => const SettingsView(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
