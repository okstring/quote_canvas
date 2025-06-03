import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quote_canvas/core/presentation/one_time_event_mixin.dart';
import 'package:quote_canvas/core/routing/router/routes.dart';
import 'package:quote_canvas/presentation/home/home_view_model.dart';
import 'package:quote_canvas/presentation/settings/settings_action.dart';
import 'package:quote_canvas/presentation/settings/settings_event.dart';
import 'package:quote_canvas/presentation/settings/settings_screen.dart';
import 'package:quote_canvas/presentation/settings/settings_view_model.dart';

class SettingsScreenRoot extends StatefulWidget {
  final SettingsViewModel viewModel;

  const SettingsScreenRoot({super.key, required this.viewModel});

  @override
  State<SettingsScreenRoot> createState() => _SettingsScreenRootState();
}

class _SettingsScreenRootState extends State<SettingsScreenRoot>
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
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.select(
      (SettingsViewModel viewModel) => viewModel.state,
    );
    final viewModel = context.read<SettingsViewModel>();

    return ListenableBuilder(
      listenable: viewModel,
      builder: (centext, __) {
        return SettingsScreen(
          state: state,
          onAction: (SettingsAction action) {
            switch (action) {
              case DeleteAllQuotes():
                viewModel.deleteAllData();
                context.pop();

                final homeViewModel = context.read<HomeViewModel>();
                homeViewModel.initialize();

                Future.delayed(const Duration(seconds: 1), () {
                  if (context.mounted) {
                    context.go(Routes.splash);
                  }
                });
                break;
              case UpdateThemeMode():
                viewModel.updateThemeMode(action.themeMode);
                break;
            }
          },
        );
      },
    );
  }
}
