import 'dart:io';

class AdHelper {
  static String get interstitialAdUnitId {
    //TODO: 실제 광고 ID로 바꿔야 함
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}