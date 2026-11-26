import 'package:flutter_test/flutter_test.dart';
import 'package:yummy/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const Yummy());
    expect(find.byType(Yummy), findsOneWidget);
  });
}
