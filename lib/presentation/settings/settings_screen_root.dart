import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quote_canvas/presentation/settings/settings_screen.dart';
import 'package:quote_canvas/presentation/settings/settings_view_model.dart';

class SettingsScreenRoot extends StatefulWidget {
  const SettingsScreenRoot({super.key});

  @override
  State<SettingsScreenRoot> createState() => _SettingsScreenRootState();
}

class _SettingsScreenRootState extends State<SettingsScreenRoot> {
  @override
  Widget build(BuildContext context) {
    final state = context.select(
      (SettingsViewModel viewModel) => viewModel.state,
    );
    final viewModel = context.read<SettingsViewModel>();

    return ListenableBuilder(
      listenable: viewModel,
      builder: (_, __) {
        return SettingsScreen(state: state);
      },
    );
  }
}
