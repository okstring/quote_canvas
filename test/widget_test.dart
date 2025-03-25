import 'package:flutter_test/flutter_test.dart';
import 'package:quote_canvas/app.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const QuoteCanvasApp());
  });
}
