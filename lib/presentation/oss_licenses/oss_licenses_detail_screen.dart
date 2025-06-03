import 'package:flutter/material.dart';
import 'package:quote_canvas/presentation/oss_licenses/oss_licenses.dart';
import 'package:quote_canvas/ui/app_colors.dart';
import 'package:quote_canvas/ui/app_text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class OssLicenseDetailScreen extends StatelessWidget {
  final Package package;

  const OssLicenseDetailScreen({super.key, required this.package});

  String _cleanLicenseText() {
    if (package.license == null || package.license!.isEmpty) {
      return 'No license information available.';
    }

    return package.license!
        .split('\n')
        .map((line) {
          // '//' 주석 제거
          if (line.startsWith('//')) {
            line = line.substring(2);
          }
          return line.trim();
        })
        .join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${package.name} ${package.version}'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0.5,
        shadowColor: Theme.of(context).shadowColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 패키지 정보 카드
            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            package.name,
                            style: AppTextStyles.headerTextBold(
                              color:
                                  Theme.of(
                                    context,
                                  ).textTheme.titleLarge?.color ??
                                  AppColors.richBlack,
                            ),
                          ),
                        ),
                        if (package.isSdk)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.navy100.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'SDK',
                              style: AppTextStyles.smallTextBold(
                                color: AppColors.navy100,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (package.version.isNotEmpty)
                      Text(
                        'Version: ${package.version}',
                        style: AppTextStyles.normalTextRegular(
                          color:
                              Theme.of(context).textTheme.bodyMedium?.color ??
                              AppColors.gray2,
                        ),
                      ),
                    if (package.description.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        package.description,
                        style: AppTextStyles.normalTextRegular(
                          color:
                              Theme.of(context).textTheme.bodyLarge?.color ??
                              AppColors.richBlack,
                        ),
                      ),
                    ],
                    if (package.authors.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Authors: ${package.authors.join(', ')}',
                        style: AppTextStyles.normalTextRegular(
                          color:
                              Theme.of(context).textTheme.bodyMedium?.color ??
                              AppColors.gray2,
                        ),
                      ),
                    ],
                    if (package.dependencies.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Dependencies: ${package.dependencies.length}',
                        style: AppTextStyles.smallTextRegular(
                          color:
                              Theme.of(context).textTheme.bodyMedium?.color ??
                              AppColors.gray2,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 라이센스 텍스트
            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'License',
                          style: AppTextStyles.normalTextBold(
                            color:
                                Theme.of(
                                  context,
                                ).textTheme.titleMedium?.color ??
                                AppColors.richBlack,
                          ),
                        ),
                        const Spacer(),
                        if (package.isMarkdown)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.navy100.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Markdown',
                              style: AppTextStyles.smallerTextRegular(
                                color: AppColors.navy100,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color:
                            Theme.of(context).brightness == Brightness.dark
                                ? AppColors.backgroundBlack
                                : AppColors.gray4.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SelectableText(
                        _cleanLicenseText(),
                        style: AppTextStyles.smallTextRegular(
                          color:
                              Theme.of(context).textTheme.bodyMedium?.color ??
                              AppColors.gray1,
                        ).copyWith(fontFamily: 'monospace', height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 홈페이지 링크
            if (package.homepage != null && package.homepage!.isNotEmpty)
              Card(
                elevation: 0,
                child: ListTile(
                  leading: Icon(Icons.home, color: AppColors.navy100),
                  title: Text(
                    'Homepage',
                    style: AppTextStyles.normalTextBold(
                      color:
                          Theme.of(context).textTheme.bodyLarge?.color ??
                          AppColors.richBlack,
                    ),
                  ),
                  subtitle: Text(
                    package.homepage!,
                    style: AppTextStyles.smallTextRegular(
                      color: AppColors.navy100,
                    ),
                  ),
                  trailing: Icon(Icons.open_in_new, color: AppColors.navy100),
                  onTap: () => _launchUrl(package.homepage!),
                ),
              ),

            // 의존성 목록 (있는 경우)
            if (package.dependencies.isNotEmpty) ...[
              const SizedBox(height: 16),
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dependencies (${package.dependencies.length})',
                        style: AppTextStyles.normalTextBold(
                          color:
                              Theme.of(context).textTheme.titleMedium?.color ??
                              AppColors.richBlack,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            package.dependencies.map((dep) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.navy100.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  dep.name,
                                  style: AppTextStyles.smallTextRegular(
                                    color: AppColors.navy100,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    try {
      final Uri url = Uri.parse(urlString);
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $urlString');
      }
    } catch (e) {
      debugPrint('URL 실행 실패: $e');
    }
  }
}
