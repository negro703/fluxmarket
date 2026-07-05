import 'package:flutter_test/flutter_test.dart';
import 'package:fluxmarket/main.dart';

void main() {
  testWidgets('App should render correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const FluxMarketApp());
    expect(find.text('FluxMarket'), findsOneWidget);
  });
}
