import 'package:flutter_test/flutter_test.dart';
import 'package:whispers/main.dart';

void main() {
  testWidgets('App renders EchoApp placeholder screen with blinking cursor', (WidgetTester tester) async {
    await tester.pumpWidget(const EchoApp());

    expect(find.text('_'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump();

    expect(find.text('_'), findsNothing);

    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump();

    expect(find.text('_'), findsOneWidget);
  });
}
