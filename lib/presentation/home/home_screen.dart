import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_image_gallery_saver/flutter_image_gallery_saver.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:quote_canvas/core/exceptions/app_exception.dart';
import 'package:quote_canvas/core/routing/router/routes.dart';
import 'package:quote_canvas/data/model/quote.dart';
import 'package:quote_canvas/presentation/components/q_interactive_bookmark_button.dart';
import 'package:quote_canvas/presentation/components/q_quote_card.dart';
import 'package:quote_canvas/presentation/components/q_refresh_button.dart';
import 'package:quote_canvas/presentation/components/q_save_button.dart';
import 'package:quote_canvas/presentation/components/q_share_button.dart';
import 'package:quote_canvas/presentation/home/home_action.dart';
import 'package:quote_canvas/presentation/home/home_state.dart';
import 'package:quote_canvas/presentation/home/home_view_model.dart';
import 'package:quote_canvas/ui/app_colors.dart';
import 'package:quote_canvas/ui/app_text_styles.dart';
import 'package:share_plus/share_plus.dart';

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
      //TODO: iOS의경우, 안드로이드 계속 거절하면?
      if (Platform.isAndroid) {
        final status = await Permission.photos.request();
        if (status.isDenied) {
          widget.onAction(
            HomeAction.readyToErrorMessage(message: '저장소 접근 권한이 필요합니다'),
          );
          return;
        }
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
