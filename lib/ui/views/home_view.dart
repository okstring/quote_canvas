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
  String? _errorMessage = null;
  Quote? _currentQuote = null;

  @override
  void initState() {
    super.initState();
    _viewModel = serviceLocator.getRequired<HomeViewModel>();
    _viewModel.addListener(_handleViewModelChange);
  }

  @override
  void dispose() {
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

  //TODO: 사진 만들기
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAFBFC),
      appBar: AppBar(
        titleSpacing: 22,
        title: const Text(
          'Quote Canvas',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: _renderAppBarIcons(context),
        elevation: 0.7,
        shadowColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _renderContents(),
        ),
      ),
    );
  }

  Widget _renderContents() {
    return Column(
      mainAxisAlignment:
          _isLoading ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        if (_isLoading)
          const CircularProgressIndicator()
        else if (_errorMessage != null)
          Text(
            _errorMessage ?? '',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          )
        else if (_currentQuote != null)
          _renderQuoteCard(_currentQuote ?? Quote.EMPTY)
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
        ElevatedButton(onPressed: _loadQuote, child: const Text('새로운 명언 보기')),
      ],
    );
  }

  List<Widget> _renderAppBarIcons(BuildContext context) {
    return [
      IconButton(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsView()),
            ),
        icon: const Icon(Icons.settings),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: IconButton(
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesView()),
              ),
          icon: const Icon(Icons.favorite),
        ),
      ),
    ];
  }

  Widget _renderQuoteCard(Quote quote) {
    const paddingValue = 16.0;

    return Container(
      height: MediaQuery.of(context).size.width - paddingValue * 2,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(paddingValue),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.format_quote, size: 34),
              const SizedBox(height: 6),
              Text(
                '${quote.content}',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                '- ${quote.author}',
                style: const TextStyle(
                  fontSize: 22,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
