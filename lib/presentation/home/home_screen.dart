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
import 'package:quote_canvas/presentation/home/home_view_model.dart';
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
  void initState() {
    super.initState();
    widget.viewModel.addListener(_handleViewModelChange);
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_handleViewModelChange);
    super.dispose();
  }

  // ViewModel 상태 변화 처리
  void _handleViewModelChange() {
    if (mounted) {
      setState(() {
        // _isLoading = widget.viewModel.isLoading;
        // _errorMessage = widget.viewModel.errorMessage;
        // _currentQuote = widget.viewModel.currentQuote;
      });
    }
  }

  // 명언 로드 메서드
  Future<void> _loadQuote() async {
    await widget.viewModel.loadQuote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFBFC),
      appBar: AppBar(
        titleSpacing: 22,
        title: const Text(
          'Quote Canvas',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: _renderAppBarIcons(context),
        elevation: 0.7,
        shadowColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, snapshot) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _renderContents(),
            ),
          );
        },
      ),
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

  Widget _renderContents() {
    return Column(
      mainAxisAlignment:
          widget.viewModel.state.isLoading
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
      children: [
        if (widget.viewModel.state.isLoading)
          const CircularProgressIndicator()
        else if (widget.viewModel.state.errorMessage != null)
          Text(
            widget.viewModel.state.errorMessage ?? '',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          )
        else
          _renderQuoteCard(widget.viewModel.state.currentQuote),

        const SizedBox(height: 40),
        ElevatedButton(onPressed: _loadQuote, child: const Text('새로운 명언 보기')),

        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: _captureAndSaveQuoteCard,
              icon: const Icon(Icons.save_alt),
              label: const Text('저장하기'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: _captureAndShareQuoteCard,
              icon: const Icon(Icons.share),
              label: const Text('공유하기'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _renderAppBarIcons(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          context.push(Routes.settings);
        },
        icon: const Icon(Icons.settings),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: IconButton(
          onPressed: () {
            context.push(Routes.favorites);
          },
          icon: const Icon(Icons.favorite),
        ),
      ),
    ];
  }

  Widget _renderQuoteCard(Quote quote) {
    const paddingValue = 16.0;

    return RepaintBoundary(
      key: _quoteCardKey,
      child: Container(
        height: MediaQuery.of(context).size.width - paddingValue * 2,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(paddingValue),
            child: Column(
              children: [
                const Icon(Icons.format_quote, size: 34),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth:
                                MediaQuery.of(context).size.width -
                                paddingValue * 4,
                          ),
                          child: Text(
                            quote.content,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '- ${quote.author}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _calculateFontSize(int length) {
    if (length < 50) {
      return 26.0;
    } else if (length < 100) {
      return 22.0;
    } else if (length < 150) {
      return 18.0;
    } else {
      return 16.0;
    }
  }
}
