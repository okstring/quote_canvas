abstract interface class AdDataSource {
  /// 전면광고 로드
  Future<void> loadInterstitialAd();
  
  /// 전면광고 표시
  Future<void> showInterstitialAd();
  
  /// 전면광고가 로드되었는지 확인
  bool get isInterstitialAdLoaded;
  
  /// 리소스 정리
  void dispose();
}
