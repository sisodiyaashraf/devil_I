import 'package:flutter_test/flutter_test.dart';
import 'package:whispers/main.dart';

void main() {
  testWidgets('App renders EchoApp placeholder screen with blinking cursor', (WidgetTester tester) async {
    await tester.pumpWidget(const EchoApp());
    await tester.pump();

    expect(find.text('_'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text(' '), findsOneWidget);
  });
}
