import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_image_gallery_saver/flutter_image_gallery_saver.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quote_canvas/core/routing/router/routes.dart';
import 'package:quote_canvas/data/model/quote.dart';
import 'package:quote_canvas/presentation/components/q_interactive_bookmark_button.dart';
import 'package:quote_canvas/presentation/components/q_quote_card.dart';
import 'package:quote_canvas/presentation/components/q_refresh_button.dart';
import 'package:quote_canvas/presentation/components/q_save_button.dart';
import 'package:quote_canvas/presentation/components/q_share_button.dart';
import 'package:quote_canvas/presentation/home/home_action.dart';
import 'package:quote_canvas/presentation/home/home_state.dart';
import 'package:quote_canvas/ui/app_colors.dart';
import 'package:quote_canvas/ui/app_text_styles.dart';

class HomeScreen extends StatefulWidget {
  final HomeState state;
  final void Function(HomeAction action) onAction;

  const HomeScreen({super.key, required this.state, required this.onAction});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey _quoteCardKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text('Quote Canvas', style: AppTextStyles.header()),
        actions: _renderAppBarIcons(context),
        elevation: 0.5,
        shadowColor: AppColors.richBlack,
        backgroundColor: AppColors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _renderContents(context),
        ),
      ),
    );
  }

  Widget _renderContents(BuildContext context) {
    final bool isLoading = widget.state.isLoading;
    final String? quoteFetchErrorMessage = widget.state.quoteFetchErrorMessage;

    return Column(
      children: [
        if (isLoading || widget.state.currentQuote.content.isEmpty)
          AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
          )
        else if (quoteFetchErrorMessage != null)
          AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                quoteFetchErrorMessage,
                style: AppTextStyles.errorNormal(),
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          _renderQuoteCard(widget.state.currentQuote),

        const SizedBox(height: 40),

        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QRefreshButton(
              onPressed: () {
                widget.onAction(ReloadQuote());
              },
            ),

            if (widget.state.currentQuote.content.isNotEmpty)
              Row(
                children: [
                  const SizedBox(width: 16),

                  QSaveButton(
                    onPressed: () {
                      _saveQuoteCard(context);
                    },
                  ),

                  const SizedBox(width: 16),

                  QShareButton(
                    onPressed: () {
                      _shareQuoteCard(context);
                    },
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  List<Widget> _renderAppBarIcons(BuildContext context) {
    return [
      QInteractiveBookmarkButton(
        onPressed: () {
          widget.onAction(HomeAction.onTapQInteractiveBookmarkButton());
        },
        isBookmarked: widget.state.currentQuote.isFavorite,
      ),
      Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: IconButton(
          onPressed: () {
            context.push(Routes.settings);
          },
          icon: const Icon(Icons.settings, color: AppColors.richBlack),
        ),
      ),
    ];
  }

  Widget _renderQuoteCard(Quote quote) {
    return RepaintBoundary(key: _quoteCardKey, child: QQuoteCard(quote: quote));
  }

  // 저장 메서드
  Future<void> _saveQuoteCard(BuildContext context) async {
    try {
      bool hasPermission = await _checkAndRequestPhotoPermission(context);
      if (!hasPermission) {
        return;
      }

      final pngBytes = await _getImageDataOrThrow(_quoteCardKey.currentContext);

      await FlutterImageGallerySaver.saveImage(pngBytes);

      widget.onAction(
        HomeAction.readyToSnackBarMessage(message: '이미지가 갤러리에 저장되었습니다'),
      );
    } catch (e, stackTrace) {
      widget.onAction(
        HomeAction.readyToErrorMessage(
          message: '이미지 저장 중 오류가 발생했습니다',
          error: e,
          stacktrace: stackTrace,
        ),
      );
    }
  }

  Future<bool> _checkAndRequestPhotoPermission(BuildContext context) async {
    Permission permission = Permission.photos;
    PermissionStatus status = await permission.status;

    // 이미 권한이 있는 경우
    if (status.isGranted) {
      return true;
    }

    // 권한이 영구적으로 거부된 경우에는 바로 설정 다이얼로그 표시
    if (status.isPermanentlyDenied) {
      widget.onAction(HomeAction.updatePhotoPermissionStatus(hasAsked: true));
      return await _showSettingsDialogAndNavigate(context);
    }

    // 첫 요청이거나 이전에 거부된 경우
    status = await permission.request();
    widget.onAction(HomeAction.updatePhotoPermissionStatus(hasAsked: true));

    // 권한 부여 여부에 따라 결과 반환
    if (status.isGranted) {
      return true;
    } else {
      return await _showSettingsDialogAndNavigate(context);
    }
  }

  // 설정 다이얼로그 표시 및 설정으로 이동
  Future<bool> _showSettingsDialogAndNavigate(BuildContext context) async {
    final bool openSettings = await _showPermissionSettingsDialog(context);
    if (openSettings) {
      await openAppSettings();
    }

    // 권한이 없으므로 항상 false 반환
    return false;
  }

  // 설정으로 이동하는 다이얼로그
  Future<bool> _showPermissionSettingsDialog(BuildContext context) async {
    if (Platform.isIOS) {
      return await showCupertinoDialog<bool>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text('권한 필요'),
          content: Text('갤러리에 이미지를 저장하려면 사진 라이브러리 접근 권한이 필요합니다. 설정으로 이동하여 권한을 허용해주세요.'),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: false,
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('취소'),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('설정으로 이동'),
            ),
          ],
        ),
      ) ?? false;
    } else {
      return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('권한 필요'),
          content: Text('갤러리에 이미지를 저장하려면 저장소 접근 권한이 필요합니다. 설정으로 이동하여 권한을 허용해주세요.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('설정으로 이동', style: TextStyle(color: Theme.of(context).primaryColor)),
            ),
          ],
        ),
      ) ?? false;
    }
  }


  // 공유 메서드
  Future<void> _shareQuoteCard(BuildContext context) async {
    try {
      final pngBytes = await _getImageDataOrThrow(_quoteCardKey.currentContext);
      widget.onAction(
        HomeAction.prepareQuoteImageForSharing(pngBytes: pngBytes),
      );
    } catch (e, stackTrace) {
      widget.onAction(
        HomeAction.readyToErrorMessage(
          message: '이미지 공유 중 오류가 발생했습니다.',
          error: e,
          stacktrace: stackTrace,
        ),
      );
    }
  }

  Future<Uint8List> _getImageDataOrThrow(BuildContext? cardContext) async {
    final RenderRepaintBoundary? boundary =
        cardContext?.findRenderObject() as RenderRepaintBoundary?;

    if (boundary == null) {
      throw Exception('렌더 경계를 찾을 수 없습니다');
    }

    final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    if (byteData == null) {
      throw Exception('이미지 데이터를 가져올 수 없습니다.');
    }

    return byteData.buffer.asUint8List();
  }
}
