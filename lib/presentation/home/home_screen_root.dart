import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quote_canvas/core/exceptions/app_exception.dart';
import 'package:quote_canvas/core/presentation/one_time_event_mixin.dart';
import 'package:quote_canvas/presentation/home/home_action.dart';
import 'package:quote_canvas/presentation/home/home_event.dart';
import 'package:quote_canvas/presentation/home/home_screen.dart';
import 'package:quote_canvas/presentation/home/home_view_model.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreenRoot extends StatefulWidget {
  const HomeScreenRoot({super.key});

  @override
  State<HomeScreenRoot> createState() => _HomeScreenRootState();
}

class _HomeScreenRootState extends State<HomeScreenRoot>
    with OneTimeEventMixin {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final viewModel = context.read<HomeViewModel>();

      listenEvent(viewModel.eventStream, (event) async {
        switch (event) {
          case ShowSnackbar():
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(event.message)));
            break;
          case ShareFile():
            if (mounted) {
              await Share.shareXFiles(
                [XFile(event.filePath)],
                text: event.text,
                subject: event.title,
              );
            }
        }
      });

      await viewModel.initialize();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.select((HomeViewModel viewModel) => viewModel.state);
    final viewModel = context.read<HomeViewModel>();

    return HomeScreen(
      state: state,
      onAction: (HomeAction action) async {
        switch (action) {
          case ReloadQuote():
            viewModel.loadQuote();
            break;
          case OnTapQInteractiveBookmarkButton():
            viewModel.toggleFavorite();
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

            viewModel.readyToErrorMessage(
              message: exception.message,
              stacktrace: exception.stackTrace,
              error: exception.error,
            );
            break;
          case ReadyToSnackBarMessage():
            viewModel.readytToShowSnackBar(message: action.message);
            break;
          case PrepareQuoteImageForSharing():
            await viewModel.saveTempQuoteImage(action.pngBytes);
            break;
          case UpdatePhotoPermissionStatus():
            viewModel.setPhotoPermissionStatus(action.hasAsked);
          case OnTapBackgroundColorSelect():
            viewModel.setQuoteBackgroundColor(action.color);
            break;
          case OnTapFontColorSelect():
            viewModel.setQuoteFontColor(action.color);
            break;
        }
      },
    );
  }
}
