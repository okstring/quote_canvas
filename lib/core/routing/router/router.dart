import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quote_canvas/core/routing/router/routes.dart';
import 'package:quote_canvas/presentation/home/home_screen_root.dart';
import 'package:quote_canvas/presentation/home/home_view_model.dart';
import 'package:quote_canvas/presentation/settings/settings_screen_root.dart';
import 'package:quote_canvas/presentation/settings/settings_view_model.dart';
import 'package:quote_canvas/presentation/splash/splash_screen.dart';

class AppRouter {
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorHomeKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: Routes.splash,
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
                path: Routes.splash,
                builder: (context, state) => const SplashScreen(),
              ),
              GoRoute(
                path: Routes.home,
                builder: (context, state) {
                  final viewModel = context.watch<HomeViewModel>();
                  return HomeScreenRoot(viewModel: viewModel);
                },
                routes: [
                  GoRoute(
                    path: Routes.settingsPath,
                    builder: (context, state) {
                      final viewModel = context.watch<SettingsViewModel>();
                      return SettingsScreenRoot(viewModel: viewModel);
                    },
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
