import 'package:quote_canvas/core/exceptions/app_exception.dart';
import 'package:quote_canvas/core/result.dart';

abstract interface class PackageInfoRepository {
  Future<Result<String, AppException>> getPackageInfo();
}
