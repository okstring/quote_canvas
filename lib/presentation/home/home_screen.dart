import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_image_gallery_saver/flutter_image_gallery_saver.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quote_canvas/data/model/quote.dart';
import 'package:quote_canvas/presentation/components/q_color_selector.dart';
import 'package:quote_canvas/presentation/components/q_half_selectable_button.dart';
import 'package:quote_canvas/presentation/components/q_interactive_bookmark_button.dart';
import 'package:quote_canvas/presentation/components/q_quote_card.dart';
import 'package:quote_canvas/presentation/components/q_refresh_button.dart';
import 'package:quote_canvas/presentation/components/q_save_button.dart';
import 'package:quote_canvas/presentation/components/q_share_button.dart';
import 'package:quote_canvas/presentation/home/home_action.dart';
import 'package:quote_canvas/presentation/home/home_state.dart';
import 'package:quote_canvas/ui/app_colors.dart';
import 'package:quote_canvas/ui/app_text_styles.dart';
import 'package:quote_canvas/utils/extensions/date_time_extension.dart';

class HomeScreen extends StatefulWidget {
  final HomeState state;
  final void Function(HomeAction action) onAction;

  const HomeScreen({super.key, required this.state, required this.onAction});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey _quoteCardKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Quote Canvas'),
        actions: _renderAppBarIcons(context),
        elevation: 0.5,
        shadowColor: Theme.of(context).shadowColor,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: SafeArea(child: _renderContents(context), bottom: false),
    );
  }

  // ===== UI 렌더링 메서드 =====

  /// 메인 컨텐츠 영역을 렌더링한다.
  /// - 명언 카드, 색상 선택기, 액션 버튼, 즐겨찾기 목록 등을 포함한다.
  Widget _renderContents(BuildContext context) {
    final bool isLoading = widget.state.isLoading;
    final String? quoteFetchErrorMessage = widget.state.quoteFetchErrorMessage;

    return ListView(
      controller: _scrollController,
      padding: EdgeInsets.all(16),
      children: [
        Column(
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

            const SizedBox(height: 32),

            HalfSelectableButton(
              onColorSelected: (color) {
                widget.onAction(HomeAction.onTapFontColorSelect(color: color));
              },
            ),

            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: QColorSelector(
                colors: AppColors.selectorColors,
                initialColor: AppColors.navy10,
                onColorSelected: (color) {
                  widget.onAction(
                    HomeAction.onTapBackgroundColorSelect(color: color),
                  );
                },
              ),
            ),

            const SizedBox(height: 32),

            _renderActionButtons(context),

            const SizedBox(height: 32),

            if (widget.state.favoriteQuotes.isNotEmpty)
              Column(
                children: [
                  Divider(height: 1, indent: 32, endIndent: 32),

                  SizedBox(height: 28),

                  Text(
                    'Favorite',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.start,
                  ),

                  SizedBox(height: 16),

                  _buildFavoritesListView(),
                ],
              ),
          ],
        ),
      ],
    );
  }

  /// 액션 버튼들(새로고침, 저장, 공유)을 렌더링한다.
  Row _renderActionButtons(BuildContext context) {
    return Row(
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
    );
  }

  /// 앱바에 표시될 아이콘들(즐겨찾기, 설정)을 렌더링한다.
  List<Widget> _renderAppBarIcons(BuildContext context) {
    return [
      QInteractiveBookmarkButton(
        onPressed: () {
          widget.onAction(HomeAction.onTapQInteractiveBookmarkButton());
        },
        isBookmarked: widget.state.currentQuote.isFavorite,
        inactiveColor: Theme.of(context).iconTheme.color ?? AppColors.white,
      ),
      Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: IconButton(
          onPressed: () {
            widget.onAction(HomeAction.onTapSettingIcon());
          },
          icon: Icon(
            Icons.settings,
            color: Theme.of(context).iconTheme.color ?? AppColors.white,
          ),
        ),
      ),
    ];
  }

  /// 명언 카드를 렌더링한다.
  /// - RepaintBoundary로 감싸서 이미지 캡처가 가능하도록 한다.
  Widget _renderQuoteCard(Quote quote) {
    return RepaintBoundary(
      key: _quoteCardKey,
      child: QQuoteCard(
        quote: quote,
        cardBackgroundColor: widget.state.quoteBackgroundColor,
        textColor: widget.state.quoteFontColor,
      ),
    );
  }

  /// 즐겨찾기 명언 목록을 렌더링한다.
  Widget _buildFavoritesListView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.state.favoriteQuotes.length, (index) {
        final quote = widget.state.favoriteQuotes[index];
        return GestureDetector(
          onTap: () {
            widget.onAction(HomeAction.onTapFavoriteQuote(quote: quote));
            _scrollToTop();
          },
          child: Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            color: widget.state.quoteBackgroundColor,
            child: ListTile(
              title: Text(
                quote.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.cardTitle(
                  color: widget.state.quoteFontColor,
                  fontSize: 16,
                ),
              ),
              subtitle: Row(
                children: [
                  Text(
                    quote.author,
                    style: AppTextStyles.authorText(
                      color: widget.state.quoteFontColor,
                      fontSize: 14,
                    ),
                  ),
                  Spacer(),
                  Text(
                    quote.favoriteDate?.toRelativeTimeString() ?? '',
                    style: AppTextStyles.smallerTextRegular(
                      fontSize: 12,
                      color: AppColors.gray2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  // ===== 이미지 저장 및 공유 관련 메서드 =====

  /// 명언 카드를 갤러리에 저장한다.
  /// 1. 권한 확인 및 요청
  /// 2. 이미지 데이터 획득
  /// 3. 갤러리에 저장
  Future<void> _saveQuoteCard(BuildContext context) async {
    try {
      bool hasPermission = await _checkAndRequestPhotoPermission(context);
      if (!hasPermission) {
        return;
      }

      final pngBytes = await _getImageDataOrThrow(_quoteCardKey.currentContext);

      widget.onAction(HomeAction.increaseAdTriggerCount(count: 2));

      await FlutterImageGallerySaver.saveImage(pngBytes);

      widget.onAction(
        HomeAction.readyToSnackBarMessage(
          message: 'Image has been saved to the gallery',
        ),
      );
    } catch (e, stackTrace) {
      widget.onAction(
        HomeAction.readyToErrorMessage(
          message: 'An error occurred while saving the image',
          error: e,
          stacktrace: stackTrace,
        ),
      );
    }
  }

  /// 명언 카드를 공유한다.
  /// 1. 이미지 데이터 획득
  /// 2. ViewModel에 공유 요청 전달
  Future<void> _shareQuoteCard(BuildContext context) async {
    try {
      final pngBytes = await _getImageDataOrThrow(_quoteCardKey.currentContext);
      widget.onAction(
        HomeAction.prepareQuoteImageForSharing(pngBytes: pngBytes),
      );
    } catch (e, stackTrace) {
      widget.onAction(
        HomeAction.readyToErrorMessage(
          message: 'An error occurred while sharing the image.',
          error: e,
          stacktrace: stackTrace,
        ),
      );
    }
  }

  // ===== 권한 관련 메서드 =====

  /// 사진 저장소 권한을 확인하고 필요시 요청한다.
  /// - 권한이 있으면 true 반환
  /// - 권한이 없고 영구 거부된 경우 설정 다이얼로그 표시
  /// - 권한 요청 후 결과 반환
  Future<bool> _checkAndRequestPhotoPermission(BuildContext context) async {
    Permission permission =
        Platform.isIOS ? Permission.photosAddOnly : Permission.photos;

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

    status = await permission.request();
    widget.onAction(HomeAction.updatePhotoPermissionStatus(hasAsked: true));

    // 권한 부여 여부에 따라 결과 반환
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      return await _showSettingsDialogAndNavigate(context);
    } else {
      widget.onAction(
        HomeAction.readyToSnackBarMessage(
          message: 'Permission is required to save images to gallery',
        ),
      );

      return false;
    }
  }

  /// 설정 다이얼로그를 표시하고 설정으로 이동한다.
  /// - 사용자가 설정으로 이동하기로 선택하면 설정 앱 열기
  Future<bool> _showSettingsDialogAndNavigate(BuildContext context) async {
    final bool openSettings = await _showPermissionSettingsDialog(context);
    if (openSettings) {
      await openAppSettings();
    }

    // 권한이 없으므로 항상 false 반환
    return false;
  }

  /// 권한 설정 다이얼로그를 표시한다.
  /// - 플랫폼(iOS/Android)에 따라 적절한 다이얼로그 표시
  Future<bool> _showPermissionSettingsDialog(BuildContext context) async {
    if (Platform.isIOS) {
      return await showCupertinoDialog<bool>(
            context: context,
            builder:
                (context) => CupertinoAlertDialog(
                  title: Text('Permission Required'),
                  content: Text(
                    'To save images to the gallery, photo library access permission is required. Please go to settings and allow the permission.',
                  ),
                  actions: [
                    CupertinoDialogAction(
                      isDefaultAction: false,
                      onPressed: () => context.pop(false),
                      child: Text('Cancel'),
                    ),
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      onPressed: () => context.pop(true),
                      child: Text('Go to Settings'),
                    ),
                  ],
                ),
          ) ??
          false;
    } else {
      return await showDialog<bool>(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: Text('Permission Required'),
                  content: Text(
                    'To save images to the gallery, storage access permission is required. Please go to settings and allow the permission.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => context.pop(false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => context.pop(true),
                      child: Text(
                        'Go to Settings',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
          ) ??
          false;
    }
  }

  // ===== 유틸리티 메서드 =====

  /// 위젯에서 이미지 데이터를 추출하여 바이트 배열로 반환한다.
  /// - 실패시 예외 발생
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

  /// 스크롤 위치를 맨 위로 이동시킨다.
  void _scrollToTop() {
    _scrollController.animateTo(
      0, // 맨 위 위치 (0)
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
