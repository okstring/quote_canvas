import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quote_canvas/core/exceptions/app_exception.dart';
import 'package:quote_canvas/core/presentation/one_time_event_mixin.dart';
import 'package:quote_canvas/core/routing/router/routes.dart';
import 'package:quote_canvas/presentation/home/home_action.dart';
import 'package:quote_canvas/presentation/home/home_event.dart';
import 'package:quote_canvas/presentation/home/home_screen.dart';
import 'package:quote_canvas/presentation/home/home_view_model.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreenRoot extends StatefulWidget {
  final HomeViewModel viewModel;

  const HomeScreenRoot({super.key, required this.viewModel});

  @override
  State<HomeScreenRoot> createState() => _HomeScreenRootState();
}

class _HomeScreenRootState extends State<HomeScreenRoot>
    with OneTimeEventMixin {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      listenEvent(widget.viewModel.eventStream, (event) async {
        switch (event) {
          case ShowSnackbar():
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(event.message)));
            break;
          case ShareFile():
            if (mounted)  {
              await Share.shareXFiles(
                [XFile(event.filePath)],
                text: event.text,
                subject: event.title,
              );

              widget.viewModel.increaseAdTriggerCount(2);
            }
        }
      });

      await widget.viewModel.initialize();
    });

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) async {
      await requestTrackingAuthorization();
    });
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreen(
      state: widget.viewModel.state,
      onAction: (HomeAction action) async {
        switch (action) {
          case ReloadQuote():
            widget.viewModel.loadQuote();
            break;
          case OnTapQInteractiveBookmarkButton():
            widget.viewModel.toggleFavorite();
            break;
          case ReadyErrorMessage():
            final exception =
                action.error is AppException
                    ? action.error as AppException
                    : AppException.ui(
                      message: action.message,
                      error: action.error,
                      stackTrace: action.stacktrace,
                    );

            widget.viewModel.readyToErrorMessage(
              message: exception.message,
              stacktrace: exception.stackTrace,
              error: exception.error,
            );
            break;
          case ReadyToSnackBarMessage():
            widget.viewModel.readytToShowSnackBar(message: action.message);
            break;
          case PrepareQuoteImageForSharing():
            await widget.viewModel.saveTempQuoteImage(action.pngBytes);
            break;
          case UpdatePhotoPermissionStatus():
            widget.viewModel.setPhotoPermissionStatus(action.hasAsked);
          case OnTapBackgroundColorSelect():
            widget.viewModel.setQuoteBackgroundColor(action.color);
            break;
          case OnTapFontColorSelect():
            widget.viewModel.setQuoteFontColor(action.color);
            break;
          case OnTapFavoriteQuote():
            widget.viewModel.selectFavoriteQuote(action.quote);
          case OnTapSettingIcon():
            context.push(Routes.settings);
          case IncreaseAdTriggerCount():
            widget.viewModel.increaseAdTriggerCount(action.count);
        }
      },
    );
  }

  Future<void> requestTrackingAuthorization() async {
    if (Platform.isIOS) {
      await Future.delayed(const Duration(milliseconds: 1000));
      await Permission.appTrackingTransparency.request();
    }
  }
}
