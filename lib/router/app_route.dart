sealed class AppRoute {
  String get path;

  String get name;

  const AppRoute();

  const factory AppRoute.home() = HomeRoute;

  const factory AppRoute.settings() = SettingsRoute;

  const factory AppRoute.favorites() = FavoritesRoute;
}

class HomeRoute extends AppRoute {
  const HomeRoute();

  @override
  String get path => '/';

  @override
  String get name => 'home';
}

class SettingsRoute extends AppRoute {
  const SettingsRoute();

  @override
  String get path => '/settings';

  @override
  String get name => 'settings';
}

class FavoritesRoute extends AppRoute {
  const FavoritesRoute();

  @override
  String get path => '/favorites';

  @override
  String get name => 'favorites';
}
