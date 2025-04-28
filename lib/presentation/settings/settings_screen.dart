import 'package:flutter/material.dart';
import 'package:quote_canvas/presentation/settings/settings_action.dart';
import 'package:quote_canvas/presentation/settings/settings_state.dart';
import 'package:quote_canvas/ui/app_colors.dart';
import 'package:quote_canvas/ui/app_text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  final SettingsState state;
  final void Function(SettingsAction action) onAction;

  const SettingsScreen({
    super.key,
    required this.state,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: AppTextStyles.header()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: AppColors.white,
        elevation: 0.5,
        shadowColor: AppColors.richBlack,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle('Data Management'),
          _buildDeleteAllDataButton(context),
          const SizedBox(height: 24),

          _buildSectionTitle('Information'),
          _buildAttributionLink(context),
          const SizedBox(height: 16),

          _buildAppVersion(context),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: AppTextStyles.normalTextBold(color: AppColors.richBlack),
      ),
    );
  }

  Widget _buildDeleteAllDataButton(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.warningLight,
      child: ListTile(
        title: Text(
          'Delete All Data',
          style: AppTextStyles.normalTextBold(color: AppColors.warning),
        ),
        subtitle: Text(
          'Delete all quotes and favorites',
          style: AppTextStyles.smallTextRegular(color: AppColors.warning),
        ),
        trailing: const Icon(Icons.delete_forever, color: AppColors.warning),
        onTap: () => _showDeleteConfirmDialog(context),
      ),
    );
  }

  Widget _buildAttributionLink(BuildContext context) {
    return Card(
      elevation: 0,
      child: ListTile(
        title: Text(
          'Quotes Provided By',
          style: AppTextStyles.normalTextRegular(color: AppColors.richBlack),
        ),
        subtitle: Text(
          'ZenQuotes API',
          style: AppTextStyles.smallTextRegular(color: AppColors.teal100),
        ),
        trailing: const Icon(Icons.open_in_new, color: AppColors.teal100),
        onTap:
            () async => await _launchExternalBrowser('https://zenquotes.io/'),
      ),
    );
  }

  Widget _buildAppVersion(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: Text(
          'Quote Canvas v${state.appVersion}',
          style: AppTextStyles.smallerTextRegular(color: AppColors.gray2),
        ),
      ),
    );
  }

  Future<void> _launchExternalBrowser(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Data Deletion'),
            content: const Text(
              'All quotes and favorites will be deleted. This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: AppTextStyles.normalTextBold(color: AppColors.gray2),
                ),
              ),
              TextButton(
                onPressed: () {
                  onAction(SettingsAction.deleteAllQuotes());
                },
                child: Text(
                  'Delete',
                  style: AppTextStyles.normalTextBold(color: AppColors.warning),
                ),
              ),
            ],
          ),
    );
  }
}
