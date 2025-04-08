import 'package:flutter/material.dart';
import 'package:quote_canvas/core/di/service_locator.dart';
import 'package:quote_canvas/ui/view_models/splash_view_model.dart';
import 'package:quote_canvas/ui/views/home_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final SplashViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = serviceLocator.getRequired<SplashViewModel>();
    _viewModel.addListener(_handleViewModelChange);
    _initializeApp();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_handleViewModelChange);
    super.dispose();
  }

  void _handleViewModelChange() {
    // ViewModel의 상태가 변경될 때 호출됨
    if (_viewModel.isInitialized && !_viewModel.isLoading && mounted) {
      // 홈 화면으로 이동
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeView()));
    }
  }

  Future<void> _initializeApp() async {
    // ViewModel에 초기화 요청
    _viewModel.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 앱 로고
            _renderAppIcon(context),
            const SizedBox(height: 24),
            // 앱 이름
            _renderAppName(),
            const SizedBox(height: 8),
            // 앱 설명
            _renderAppDescription(),
            const SizedBox(height: 48),
            // 로딩 인디케이터
            CircularProgressIndicator(color: Theme.of(context).primaryColor),

            // 에러 메시지 (있는 경우)
            if (_viewModel.errorMessage != null) ...[
              const SizedBox(height: 24),
              Text(
                _viewModel.errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _renderAppIcon(BuildContext context) {
    return Icon(
      Icons.format_quote_rounded,
      size: 80,
      color: Theme.of(context).primaryColor,
    );
  }

  Widget _renderAppName() {
    return const Text(
      'Quote Canvas',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        fontFamily: 'Pretendard',
      ),
    );
  }

  Widget _renderAppDescription() {
    return const Text(
      '당신의 하루를 위한 명언 갤러리',
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey,
        fontFamily: 'Pretendard',
      ),
    );
  }
}
