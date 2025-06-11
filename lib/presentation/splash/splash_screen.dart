import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quote_canvas/core/routing/router/routes.dart';
import 'package:quote_canvas/presentation/splash/splash_view_model.dart';
import 'package:quote_canvas/ui/app_colors.dart';
import 'package:quote_canvas/ui/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // ATT 요청
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) async {
      await AppTrackingTransparency.requestTrackingAuthorization();
    });

    Future.microtask(() async {
      final viewModel = context.read<SplashViewModel>();
      await viewModel.initialize(() {
        if (mounted) {
          context.pushReplacement(Routes.home);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _renderAppName(),
            const SizedBox(height: 8),

            _renderAppDescription(),
            const SizedBox(height: 48),

            CircularProgressIndicator(color: Theme.of(context).primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _renderAppName() {
    return Text(
      'Quote Canvas',
      style: AppTextStyles.headerTextBold(color: AppColors.richBlack),
    );
  }

  Widget _renderAppDescription() {
    return Text(
      'Sayings for Your Day Gallery',
      style: AppTextStyles.mediumTextRegular(color: AppColors.richBlack),
    );
  }
}
