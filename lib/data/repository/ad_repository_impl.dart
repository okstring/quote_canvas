import 'package:quote_canvas/core/exceptions/app_exception.dart';
import 'package:quote_canvas/core/result.dart';
import 'package:quote_canvas/data/data_source/ad/ad_data_source.dart';
import 'ad_repository.dart';

class AdRepositoryImpl implements AdRepository {
  final AdDataSource _adDataSource;

  AdRepositoryImpl({required AdDataSource adDataSource}) 
      : _adDataSource = adDataSource;

  @override
  bool get isInterstitialAdLoaded => _adDataSource.isInterstitialAdLoaded;

  @override
  Future<Result<void, AppException>> loadInterstitialAd() async {
    try {
      await _adDataSource.loadInterstitialAd();
      return const Result.success(null);
    } catch (e, stackTrace) {
      if (e is AppException) {
        return Result.error(e);
      }
      
      return Result.error(
        AppException.ad(
          message: '광고를 로드하는 중 오류가 발생했습니다.',
          error: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<void, AppException>> showInterstitialAd() async {
    try {
      await _adDataSource.showInterstitialAd();
      return const Result.success(null);
    } catch (e, stackTrace) {
      if (e is AppException) {
        return Result.error(e);
      }
      
      return Result.error(
        AppException.ad(
          message: '광고를 표시하는 중 오류가 발생했습니다.',
          error: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  void dispose() {
    _adDataSource.dispose();
  }
}
