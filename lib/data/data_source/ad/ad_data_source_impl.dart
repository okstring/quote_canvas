import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quote_canvas/core/exceptions/app_exception.dart';
import 'package:quote_canvas/core/helper/ad_helper.dart';
import 'package:quote_canvas/utils/logger.dart';
import 'ad_data_source.dart';

class AdDataSourceImpl implements AdDataSource {
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdLoaded = false;

  @override
  bool get isInterstitialAdLoaded => _isInterstitialAdLoaded;

  @override
  Future<void> loadInterstitialAd() async {
    try {
      await InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            _isInterstitialAdLoaded = true;

            _setupAdCallbacks(ad);
          },
          onAdFailedToLoad: (LoadAdError error) {
            logger.error('전면광고 로드 실패', error: error);
            _isInterstitialAdLoaded = false;
            throw AppException.ad(
              message: '광고를 불러오는 중 오류가 발생했습니다.',
              error: error,
            );
          },
        ),
      );
    } catch (e, stackTrace) {
      logger.error('전면광고 로드 중 예외 발생', error: e, stackTrace: stackTrace);
      _isInterstitialAdLoaded = false;
      throw AppException.ad(
        message: '광고를 불러오는 중 오류가 발생했습니다.',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> showInterstitialAd() async {
    if (_interstitialAd == null || !_isInterstitialAdLoaded) {
      logger.warning('전면광고가 로드되지 않았습니다');
      throw AppException.ad(
        message: '광고를 표시할 준비가 되지 않았습니다.',
      );
    }

    try {
      await _interstitialAd!.show();
    } catch (e, stackTrace) {
      logger.error('전면광고 표시 중 예외 발생', error: e, stackTrace: stackTrace);
      throw AppException.ad(
        message: '광고를 표시하는 중 오류가 발생했습니다.',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  void _setupAdCallbacks(InterstitialAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        logger.info('전면광고가 전체 화면으로 표시됨');
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        logger.info('전면광고가 닫힘');
        ad.dispose();
        _interstitialAd = null;
        _isInterstitialAdLoaded = false;

        // 다음 광고를 미리 로드
        loadInterstitialAd().catchError((error) {
          logger.error('다음 전면광고 사전 로드 실패', error: error);
        });
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        logger.error('전면광고 표시 실패', error: error);
        ad.dispose();
        _interstitialAd = null;
        _isInterstitialAdLoaded = false;
      },
    );
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isInterstitialAdLoaded = false;
  }
}
