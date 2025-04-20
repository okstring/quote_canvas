import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quote_canvas/core/routing/router/routes.dart';
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
    _initializeApp();
  }

  //TODO: viewModel로 옮기기
  Future<void> _initializeApp() async {
    // 1.5초 후에 홈 화면으로 이동
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      context.pushReplacement(Routes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 앱 이름
            _renderAppName(),
            const SizedBox(height: 8),
            // 앱 설명
            _renderAppDescription(),
            const SizedBox(height: 48),
            // 로딩 인디케이터
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
      '당신의 하루를 위한 명언 갤러리',
      style: AppTextStyles.mediumTextRegular(color: AppColors.richBlack),
    );
  }
}