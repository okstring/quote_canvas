enum QuoteLanguage {
  korean('ko'),
  english('en');

  final String code;

  const QuoteLanguage(this.code);

  static QuoteLanguage fromCode(String code) {
    switch (code) {
      case 'ko':
        return korean;
      case 'en':
        return english;
      default:
        return english;
    }
  }
}
