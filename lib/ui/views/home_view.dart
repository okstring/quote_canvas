import 'package:flutter/material.dart';
import 'package:quote_canvas/data/model_class/quote.dart';
import 'package:quote_canvas/UI/view_models/home_view_model.dart';
import 'package:quote_canvas/UI/views/favorites_view.dart';
import 'package:quote_canvas/core/di/service_locator.dart';
import 'package:quote_canvas/ui/views/settings_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeViewModel _viewModel;
  bool _isLoading = false;
  String? _errorMessage;
  Quote? _currentQuote;

  @override
  void initState() {
    super.initState();
    _viewModel = serviceLocator.getRequired<HomeViewModel>();
    // ViewModel 상태 변화 리스너 추가
    _viewModel.addListener(_handleViewModelChange);
  }

  @override
  void dispose() {
    // 리스너 제거
    _viewModel.removeListener(_handleViewModelChange);
    super.dispose();
  }

  // ViewModel 상태 변화 처리
  void _handleViewModelChange() {
    if (mounted) {
      setState(() {
        _isLoading = _viewModel.isLoading;
        _errorMessage = _viewModel.errorMessage;
        _currentQuote = _viewModel.currentQuote;
      });
    }
  }

  // 명언 로드 메서드
  Future<void> _loadQuote() async {
    await _viewModel.loadQuote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quote Canvas'),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsView()),
            ),
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FavoritesView(),
              ),
            ),
            icon: const Icon(Icons.favorite),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '매일 새로운 명언과 함께 영감을 채우는 나만의 지혜 갤러리',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              if (_isLoading)
                const CircularProgressIndicator()
              else if (_errorMessage != null)
                Text(
                  _errorMessage ?? '',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                )
              else if (_currentQuote != null)
                  _buildQuoteCard(_currentQuote ?? Quote.EMPTY)
                else
                  Text(
                    '당신의 하루를 빛내줄 명언이 곧 여기에 표시됩니다.',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),

              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: _loadQuote,
                child: const Text('새로운 명언 보기'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuoteCard(Quote quote) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              quote.content,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              '- ${quote.author}',
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }
}