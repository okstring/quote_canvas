import 'dart:typed_data';

import 'package:quote_canvas/core/exceptions/app_exception.dart';
import 'package:quote_canvas/core/result.dart';

abstract interface class FileRepository {
  Future<Result<String, AppException>> saveTempQuoteImage(Uint8List pngBytes);
}
