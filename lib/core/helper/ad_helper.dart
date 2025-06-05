import 'dart:io';

class AdHelper {
  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6198172205965396/5836858996';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6198172205965396/5854826829';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}