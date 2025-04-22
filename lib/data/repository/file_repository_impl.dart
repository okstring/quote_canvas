import 'package:flutter/foundation.dart';
import 'package:quote_canvas/core/exceptions/app_exception.dart';
import 'package:quote_canvas/data/data_source/file_service/file_data_source.dart';
import 'package:quote_canvas/core/result.dart';

import './file_repository.dart';

class FileRepositoryImpl implements FileRepository {
  final FileDataSource _fileDataSource;

  const FileRepositoryImpl({
    required FileDataSource fileDataSource,
  }) : _fileDataSource = fileDataSource;

  Future<Result<String, AppException>> saveTempQuoteImage(Uint8List pngBytes) async {
    try {
      final filePath = await _fileDataSource.saveTempQuotePicture(pngBytes);
      return Result.success(filePath);
    } catch (e, stackTrack){
      return Result.error(
        AppException.file(
          message: '이미지를 저장하는 중 오류가 발생했습니다.',
          error: e,
          stackTrace: stackTrack,
        ),
      );
    }
  }
}
