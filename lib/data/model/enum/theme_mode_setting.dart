enum ThemeModeSetting {
  system,
  light,
  dark;

  static ThemeModeSetting fromString(String? value) {
    switch (value) {
      case 'dark':
        return ThemeModeSetting.dark;
      case 'light':
        return ThemeModeSetting.light;
      default:
        return ThemeModeSetting.system;
    }
  }

  String get value {
    switch (this) {
      case ThemeModeSetting.dark:
        return 'dark';
      case ThemeModeSetting.light:
        return 'light';
      case ThemeModeSetting.system:
        return 'system';
    }
  }
}
