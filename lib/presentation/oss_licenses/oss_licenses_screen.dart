import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quote_canvas/presentation/oss_licenses/oss_licenses.dart';
import 'package:quote_canvas/presentation/oss_licenses/oss_licenses_detail_screen.dart';
import 'package:quote_canvas/ui/app_colors.dart';
import 'package:quote_canvas/ui/app_text_styles.dart';

class OssLicensesScreen extends StatelessWidget {
  const OssLicensesScreen({super.key});

  static Future<List<Package>> loadLicenses() async {
    final licenseMap = <String, List<String>>{};

    await for (var license in LicenseRegistry.licenses) {
      for (var packageName in license.packages) {
        final licenseList = licenseMap.putIfAbsent(packageName, () => []);
        licenseList.addAll(
          license.paragraphs.map((paragraph) => paragraph.text),
        );
      }
    }

    final licenses = allDependencies.toList();

    for (var packageName in licenseMap.keys) {
      final existingPackage = licenses.where((pkg) => pkg.name == packageName);
      if (existingPackage.isEmpty) {
        licenses.add(
          Package(
            name: packageName,
            description: '',
            authors: [],
            version: '',
            license: licenseMap[packageName]!.join('\n\n'),
            isMarkdown: false,
            isSdk: false,
            dependencies: [],
          ),
        );
      }
    }

    return licenses..sort((a, b) => a.name.compareTo(b.name));
  }

  static final _licenses = loadLicenses();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Open Source Licenses'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0.5,
        shadowColor: Theme.of(context).shadowColor,
      ),
      body: FutureBuilder<List<Package>>(
        future: _licenses,
        initialData: const [],
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.warning),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load licenses',
                    style: AppTextStyles.normalTextBold(
                      color:
                          Theme.of(context).textTheme.bodyLarge?.color ??
                          AppColors.richBlack,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    style: AppTextStyles.smallTextRegular(
                      color: AppColors.warning,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final packages = snapshot.data ?? [];

          if (packages.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.description_outlined,
                    size: 64,
                    color: AppColors.gray3,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No licenses found',
                    style: AppTextStyles.normalTextBold(
                      color:
                          Theme.of(context).textTheme.bodyLarge?.color ??
                          AppColors.richBlack,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: packages.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final package = packages[index];

              return Card(
                elevation: 0,
                child: ListTile(
                  title: Text(
                    '${package.name} ${package.version}',
                    style: AppTextStyles.normalTextBold(
                      color:
                          Theme.of(context).textTheme.bodyLarge?.color ??
                          AppColors.richBlack,
                    ),
                  ),
                  subtitle:
                      package.description.isNotEmpty
                          ? Text(
                            package.description,
                            style: AppTextStyles.smallTextRegular(
                              color:
                                  Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.color ??
                                  AppColors.gray2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                          : package.authors.isNotEmpty
                          ? Text(
                            'Authors: ${package.authors.join(', ')}',
                            style: AppTextStyles.smallTextRegular(
                              color:
                                  Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.color ??
                                  AppColors.gray2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                          : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (package.isSdk)
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
                            'SDK',
                            style: AppTextStyles.smallerTextBold(
                              color: AppColors.navy100,
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.chevron_right,
                        color:
                            Theme.of(context).iconTheme.color ??
                            AppColors.gray2,
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                OssLicenseDetailScreen(package: package),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
