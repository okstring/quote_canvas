import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quote_canvas/presentation/settings/settings_state.dart';
import 'package:quote_canvas/presentation/settings/settings_view_model.dart';
import 'package:quote_canvas/ui/app_colors.dart';
import 'package:quote_canvas/ui/app_text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  final SettingsState state;

  const SettingsScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SettingsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('설정', style: AppTextStyles.header()),
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
          _buildSectionTitle('데이터 관리'),
          _buildDeleteAllDataButton(context, viewModel),
          const SizedBox(height: 24),

          _buildSectionTitle('정보'),
          _buildAttributionLink(),
          const SizedBox(height: 16),

          _buildAppVersion(),
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

  Widget _buildDeleteAllDataButton(
    BuildContext context,
    SettingsViewModel viewModel,
  ) {
    return Card(
      elevation: 0,
      color: AppColors.warningLight,
      child: ListTile(
        title: Text(
          '모든 데이터 지우기',
          style: AppTextStyles.normalTextBold(color: AppColors.warning),
        ),
        subtitle: Text(
          '모든 명언 데이터와 즐겨찾기를 삭제합니다',
          style: AppTextStyles.smallTextRegular(color: AppColors.warning),
        ),
        trailing: const Icon(Icons.delete_forever, color: AppColors.warning),
        onTap: () => _showDeleteConfirmDialog(context, viewModel),
      ),
    );
  }

  Widget _buildAttributionLink() {
    return Card(
      elevation: 0,
      child: ListTile(
        title: Text(
          '명언 제공',
          style: AppTextStyles.normalTextRegular(color: AppColors.richBlack),
        ),
        subtitle: Text(
          'ZenQuotes API',
          style: AppTextStyles.smallTextRegular(color: AppColors.teal100),
        ),
        trailing: const Icon(Icons.open_in_new, color: AppColors.teal100),
        onTap: () => _launchUrl('https://zenquotes.io/'),
      ),
    );
  }

  Widget _buildAppVersion() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: Text(
          'Quote Canvas v1.0.0',
          style: AppTextStyles.smallerTextRegular(color: AppColors.gray2),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  void _showDeleteConfirmDialog(
    BuildContext context,
    SettingsViewModel viewModel,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('데이터 삭제 확인'),
            content: const Text('모든 명언 데이터와 즐겨찾기가 삭제됩니다. 이 작업은 되돌릴 수 없습니다.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  '취소',
                  style: AppTextStyles.normalTextBold(color: AppColors.gray2),
                ),
              ),
              TextButton(
                onPressed: () {
                  viewModel.deleteAllData();
                  Navigator.pop(context);
                },
                child: Text(
                  '삭제',
                  style: AppTextStyles.normalTextBold(color: AppColors.warning),
                ),
              ),
            ],
          ),
    );
  }
}
