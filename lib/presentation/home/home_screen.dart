import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_image_gallery_saver/flutter_image_gallery_saver.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quote_canvas/core/routing/router/routes.dart';
import 'package:quote_canvas/data/model/quote.dart';
import 'package:quote_canvas/presentation/components/q_refresh_button.dart';
import 'package:quote_canvas/presentation/components/q_interactive_bookmark_button.dart';
import 'package:quote_canvas/presentation/components/q_quote_card.dart';
import 'package:quote_canvas/presentation/components/q_save_button.dart';
import 'package:quote_canvas/presentation/components/q_share_button.dart';
import 'package:quote_canvas/presentation/home/home_view_model.dart';
import 'package:quote_canvas/ui/app_colors.dart';
import 'package:quote_canvas/ui/app_text_styles.dart';
import 'package:quote_canvas/utils/logger.dart';

class HomeScreen extends StatefulWidget {
  final HomeViewModel viewModel;

  const HomeScreen({super.key, required this.viewModel});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey _quoteCardKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Quote Canvas', style: AppTextStyles.header()),
        actions: _renderAppBarIcons(context),
        elevation: 0.7,
        shadowColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, snapshot) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _renderContents(),
            ),
          );
        },
      ),
    );
  }

  Widget _renderContents() {
    final bool isLoading = widget.viewModel.state.isLoading;
    final String? errorMessage = widget.viewModel.state.errorMessage;

    return Column(
      children: [
        if (isLoading)
          Center(child: const CircularProgressIndicator())
        else if (errorMessage != null)
          Center(
            child: Text(
              errorMessage,
              style: AppTextStyles.errorNormal(),
              textAlign: TextAlign.center,
            ),
          )
        else
          _renderQuoteCard(widget.viewModel.state.currentQuote),

        const SizedBox(height: 40),

        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QRefreshButton(onPressed: widget.viewModel.loadQuote),

            const SizedBox(width: 16),

            QSaveButton(onPressed: _captureAndSaveQuoteCard),

            const SizedBox(width: 16),

            QShareButton(onPressed: _captureAndShareQuoteCard),
          ],
        ),
      ],
    );
  }

  List<Widget> _renderAppBarIcons(BuildContext context) {
    return [
      QInteractiveBookmarkButton(onPressed: () {
        //TODO: 북마크 기능 활성화
      }),
      Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: IconButton(
          onPressed: () {
            context.push(Routes.settings);
          },
          icon: const Icon(Icons.settings, color: AppColors.richBlack,),
        ),
      ),
    ];
  }

  Widget _renderQuoteCard(Quote quote) {
    const paddingValue = 16.0;

    return RepaintBoundary(
      key: _quoteCardKey,
      child: QQuoteCard(quote: quote),
    );
  }

  // TODO: 카드 저장 리팩토링
  // 이미지 캡처 및 저장 메서드
  Future<void> _captureAndSaveQuoteCard() async {
    try {
      // 권한 요청
      if (Platform.isAndroid) {
        final status = await Permission.photos.request();
        if (status.isDenied) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('저장소 접근 권한이 필요합니다')));
          }
          return;
        }
      }

      // setState(() {
      //   _isLoading = true;
      // });

      // 현재 명언 카드 위젯을 이미지로 캡처
      final RenderRepaintBoundary? boundary =
          _quoteCardKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;

      if (boundary == null) {
        logger.error('렌더 경계를 찾을 수 없습니다');
        return;
      }

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        logger.error('이미지 데이터를 가져올 수 없습니다');
        return;
      }

      final Uint8List pngBytes = byteData.buffer.asUint8List();

      // 이미지 갤러리에 직접 저장
      final result = await FlutterImageGallerySaver.saveImage(pngBytes);

      // setState(() {
      //   _isLoading = false;
      // });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('이미지가 갤러리에 저장되었습니다')));
    } catch (e, stackTrace) {
      logger.error('이미지 저장 중 오류 발생', error: e, stackTrace: stackTrace);
      // setState(() {
      //   _isLoading = false;
      // });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('오류가 발생했습니다: $e')));
      }
    }
  }

  // 이미지 캡처 및 공유 메서드
  Future<void> _captureAndShareQuoteCard() async {
    try {
      // setState(() {
      //   _isLoading = true;
      // });

      // 현재 명언 카드 위젯을 이미지로 캡처
      final RenderRepaintBoundary? boundary =
          _quoteCardKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;

      if (boundary == null) {
        logger.error('렌더 경계를 찾을 수 없습니다');
        return;
      }

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        logger.error('이미지 데이터를 가져올 수 없습니다');
        return;
      }

      final Uint8List pngBytes = byteData.buffer.asUint8List();

      // 임시 파일로 저장
      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/quote_canvas_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(pngBytes);

      // setState(() {
      //   _isLoading = false;
      // });

      // 파일 공유
      // if (_currentQuote != null && mounted) {
      //   await Share.shareXFiles(
      //     [XFile(file.path)],
      //     text: '${_currentQuote?.content} - ${_currentQuote?.author}',
      //     subject: 'Quote Canvas',
      //   );
      // }
    } catch (e, stackTrace) {
      logger.error('이미지 공유 중 오류 발생', error: e, stackTrace: stackTrace);
      // setState(() {
      //   _isLoading = false;
      // });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('오류가 발생했습니다: $e')));
      }
    }
  }
}
