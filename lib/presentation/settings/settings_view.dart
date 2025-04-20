import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quote_canvas/presentation/settings/settings_view_model.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SettingsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('설정 화면 내용이 여기에 표시됩니다.'),
      ),
    );
  }
}