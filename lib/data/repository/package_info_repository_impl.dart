import 'package:quote_canvas/core/exceptions/app_exception.dart';

import 'package:quote_canvas/core/result.dart';
import 'package:quote_canvas/utils/logger.dart';

import './package_info_repository.dart';
import '../data_source/package_info/package_info_data_source.dart';

class PackageInfoRepositoryImpl implements PackageInfoRepository {
  final PackageInfoDataSource _packageInfoDataSource;

  const PackageInfoRepositoryImpl({
    required PackageInfoDataSource packageInfoDataSource,
  }) : _packageInfoDataSource = packageInfoDataSource;

  @override
  Future<Result<String, AppException>> getPackageInfo() async {
    try {
      final result = await _packageInfoDataSource.getPackageInfo();
      return Result.success(result);
    } on AppException catch (e, stackTrack) {
      logger.info(e.toString(), error: e, stackTrace: stackTrack);
      return Result.error(e);
    } catch (e, stackTrack) {
      logger.info(e.toString(), error: e, stackTrace: stackTrack);
      return Result.error(
          AppException.file(
            message: '앱 버전을 가져오는 중 오류가 발생했습니다.',
            error: e,
            stackTrace: stackTrack,
          )
      );
    }
  }
}
