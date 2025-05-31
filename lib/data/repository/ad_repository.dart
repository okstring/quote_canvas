import 'package:quote_canvas/core/exceptions/app_exception.dart';
import 'package:quote_canvas/core/result.dart';

abstract interface class AdRepository {
  /// 전면광고 로드
  Future<Result<void, AppException>> loadInterstitialAd();
  
  /// 전면광고 표시
  Future<Result<void, AppException>> showInterstitialAd();
  
  /// 전면광고가 로드되었는지 확인
  bool get isInterstitialAdLoaded;
  
  /// 리소스 정리
  void dispose();
}
