import 'package:package_info_plus/package_info_plus.dart';
import 'package:quote_canvas/utils/logger.dart';

import 'package_info_data_source.dart';

class PackageInfoDataSourceImpl implements PackageInfoDataSource {
  Future<String> getPackageInfo() async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    } catch (e, stackTrace) {
      logger.error(
        'Failed to get app version',
        error: e,
        stackTrace: stackTrace,
      );
      return '0.0.0';
    }
  }
}
