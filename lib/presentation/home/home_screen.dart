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
import 'package:quote_canvas/presentation/home/home_view_model.dart';
import 'package:quote_canvas/ui/app_colors.dart';
import 'package:quote_canvas/ui/app_text_styles.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey _quoteCardKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final viewModel = context.read<HomeViewModel>();
      await viewModel.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    if (viewModel.state.errorMessage != null) {
      _showSnackBar(context, message: viewModel.state.errorMessage ?? '');
      viewModel.clearErrorMessage();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Quote Canvas', style: AppTextStyles.header()),
        actions: _renderAppBarIcons(context, viewModel),
        elevation: 0.7,
        shadowColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _renderContents(context, viewModel),
        ),
      ),
    );
  }

  Widget _renderContents(BuildContext context, HomeViewModel viewModel) {
    final bool isLoading = viewModel.state.isLoading;
    final String? errorMessage = viewModel.state.errorMessage;

    return Column(
      children: [
        if (isLoading)
          AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
          )
        else if (errorMessage != null)
          AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                errorMessage,
                style: AppTextStyles.errorNormal(),
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          _renderQuoteCard(viewModel.state.currentQuote),

        const SizedBox(height: 40),

        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QRefreshButton(onPressed: viewModel.loadQuote),

            const SizedBox(width: 16),

            QSaveButton(onPressed: () {
              _saveQuoteCard(context, viewModel);
            }),

            const SizedBox(width: 16),

            QShareButton(
              onPressed: () {
                _shareQuoteCard(context, viewModel);
              },
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _renderAppBarIcons(
    BuildContext context,
    HomeViewModel viewModel,
  ) {
    return [
      QInteractiveBookmarkButton(
        onPressed: viewModel.toggleFavorite,
        isBookmarked: viewModel.state.currentQuote.isFavorite,
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
  Future<void> _saveQuoteCard(
    BuildContext context,
    HomeViewModel viewModel,
  ) async {
    try {
      if (Platform.isAndroid) {
        final status = await Permission.photos.request();
        if (status.isDenied) {
          _showSnackBar(context, message: '저장소 접근 권한이 필요합니다');
          return;
        }
      }
      final pngBytes = await _getImageDataOrThrow(_quoteCardKey.currentContext);

      await FlutterImageGallerySaver.saveImage(pngBytes);

      _showSnackBar(context, message: '이미지가 갤러리에 저장되었습니다');
    } catch (e, stackTrace) {
      viewModel.readyErrorMessage(
        message: '이미지 저장 중 오류가 발생했습니다.',
        error: e,
        stacktrace: stackTrace,
      );
    }
  }

  // 공유 메서드
  Future<void> _shareQuoteCard(
    BuildContext context,
    HomeViewModel viewModel,
  ) async {
    try {
      final pngBytes = await _getImageDataOrThrow(_quoteCardKey.currentContext);

      final filePath = await viewModel.saveTempQuoteImageOrThrow(pngBytes);

      if (mounted) {
        await Share.shareXFiles(
          [XFile(filePath)],
          text: viewModel.shareText,
          subject: viewModel.shareTitle,
        );
      }
    } on AppException catch (e, stackTrace) {
      viewModel.readyErrorMessage(
        message: e.userFriendlyMessage,
        error: e,
        stacktrace: stackTrace,
      );
    } catch (e, stackTrace) {
      viewModel.readyErrorMessage(
        message: '이미지 공유 중 오류가 발생했습니다.',
        error: e,
        stacktrace: stackTrace,
      );
    }
  }

  Future<Uint8List> _getImageDataOrThrow(BuildContext? cardContext) async {
    final RenderRepaintBoundary? boundary =
        cardContext?.findRenderObject() as RenderRepaintBoundary?;

    if (boundary == null) {
      final errorMessage = '렌더 경계를 찾을 수 없습니다';
      throw AppException.ui(message: errorMessage);
    }

    final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    if (byteData == null) {
      final errorMessage = '이미지 데이터를 가져올 수 없습니다.';
      throw AppException.ui(message: errorMessage);
    }

    return byteData.buffer.asUint8List();
  }

  void _showSnackBar(BuildContext context, {required String message}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
      );
    }
  }
}
