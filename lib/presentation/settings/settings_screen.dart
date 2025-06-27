import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quote_canvas/data/model/enum/theme_mode_setting.dart';
import 'package:quote_canvas/presentation/oss_licenses/oss_licenses_screen.dart';
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
        title: Text('Settings'),
        leading:
            Platform.isIOS
                ? CupertinoNavigationBarBackButton(
                  onPressed: () => Navigator.pop(context),
                )
                : IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: Platform.isIOS ? 0 : 0.5,
        shadowColor: Theme.of(context).shadowColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle(context, 'Appearance'),
          _buildThemeSection(context),
          const SizedBox(height: 24),

          _buildSectionTitle(context, 'Data Management'),
          _buildDeleteAllDataButton(context),
          const SizedBox(height: 24),

          _buildSectionTitle(context, 'Information'),
          _buildAttributionLink(context),
          const SizedBox(height: 8),
          _buildLicensesButton(context), // 새로 추가된 라이센스 버튼
          const SizedBox(height: 16),

          _buildAppVersion(context),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: AppTextStyles.normalTextBold(
          color:
              Theme.of(context).textTheme.bodyLarge?.color ??
              AppColors.richBlack,
        ),
      ),
    );
  }

  Widget _buildThemeSection(BuildContext context) {
    return Card(
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Theme',
              style: AppTextStyles.normalTextBold(
                color:
                    Theme.of(context).textTheme.bodyLarge?.color ??
                    AppColors.richBlack,
              ),
            ),
          ),
          RadioListTile<ThemeModeSetting>(
            title: Text(
              'System Theme',
              style: AppTextStyles.normalTextRegular(
                color:
                    Theme.of(context).textTheme.bodyMedium?.color ??
                    AppColors.gray2,
              ),
            ),
            value: ThemeModeSetting.system,
            groupValue: state.settings.themeMode,
            onChanged: (value) {
              if (value != null) {
                onAction(SettingsAction.updateThemeMode(themeMode: value));
              }
            },
          ),
          RadioListTile<ThemeModeSetting>(
            title: Text(
              'Light Theme',
              style: AppTextStyles.normalTextRegular(
                color:
                    Theme.of(context).textTheme.bodyMedium?.color ??
                    AppColors.gray2,
              ),
            ),
            value: ThemeModeSetting.light,
            groupValue: state.settings.themeMode,
            onChanged: (value) {
              if (value != null) {
                onAction(SettingsAction.updateThemeMode(themeMode: value));
              }
            },
          ),
          RadioListTile<ThemeModeSetting>(
            title: Text(
              'Dark Theme',
              style: AppTextStyles.normalTextRegular(
                color:
                    Theme.of(context).textTheme.bodyMedium?.color ??
                    AppColors.gray2,
              ),
            ),
            value: ThemeModeSetting.dark,
            groupValue: state.settings.themeMode,
            onChanged: (value) {
              if (value != null) {
                onAction(SettingsAction.updateThemeMode(themeMode: value));
              }
            },
          ),
        ],
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
          style: AppTextStyles.normalTextRegular(
            color:
                Theme.of(context).textTheme.bodyLarge?.color ??
                AppColors.richBlack,
          ),
        ),
        subtitle: Text(
          'ZenQuotes API',
          style: AppTextStyles.smallTextRegular(color: AppColors.navy100),
        ),
        trailing: const Icon(Icons.open_in_new, color: AppColors.navy100),
        onTap:
            () async => await _launchExternalBrowser('https://zenquotes.io/'),
      ),
    );
  }

  Widget _buildLicensesButton(BuildContext context) {
    return Card(
      elevation: 0,
      child: ListTile(
        leading: Icon(Icons.article_outlined, color: AppColors.navy100),
        title: Text(
          'Open Source Licenses',
          style: AppTextStyles.normalTextRegular(
            color:
                Theme.of(context).textTheme.bodyLarge?.color ??
                AppColors.richBlack,
          ),
        ),
        subtitle: Text(
          'View licenses of open source libraries',
          style: AppTextStyles.smallTextRegular(color: AppColors.gray2),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.navy100),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const OssLicensesScreen()),
          );
        },
      ),
    );
  }

  Widget _buildAppVersion(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: Text(
          'Quote Canvas v${state.appVersion}',
          style: AppTextStyles.smallerTextRegular(
            color:
                Theme.of(context).textTheme.bodySmall?.color ?? AppColors.gray3,
          ),
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
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(
            'Delete All Data',
            style: AppTextStyles.normalTextBold(color: AppColors.warning),
          ),
          content: Text(
            'Are you sure you want to delete all quotes and favorites? This action cannot be undone.',
            style: AppTextStyles.normalTextRegular(
              // 테마 기반 색상 사용으로 다크모드 지원
              color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.richBlack,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: AppTextStyles.normalTextRegular(
                  color: AppColors.gray2,
                ),
              ),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context);
                onAction(const SettingsAction.deleteAllQuotes());
              },
              child: Text(
                'Delete',
                style: AppTextStyles.normalTextBold(
                  color: AppColors.warning,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Delete All Data',
            style: AppTextStyles.normalTextBold(color: AppColors.warning),
          ),
          content: Text(
            'Are you sure you want to delete all quotes and favorites? This action cannot be undone.',
            style: AppTextStyles.normalTextRegular(
              // 테마 기반 색상 사용으로 다크모드 지원
              color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.richBlack,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: AppTextStyles.normalTextRegular(
                  color: AppColors.gray2,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onAction(const SettingsAction.deleteAllQuotes());
              },
              child: Text(
                'Delete',
                style: AppTextStyles.normalTextBold(
                  color: AppColors.warning,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
