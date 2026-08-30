import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:devil_i/main.dart';
import 'package:devil_i/presentation/providers/devil_provider.dart';
import 'package:devil_i/presentation/providers/focus_provider.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App renders ContractScreen when onboarding is not completed', (WidgetTester tester) async {
    final devilProvider = DevilProvider();
    final focusProvider = FocusProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<DevilProvider>.value(value: devilProvider),
          ChangeNotifierProvider<FocusProvider>.value(value: focusProvider),
        ],
        child: const DevilIApp(hasSigned: false),
      ),
    );

    // Let the first frame render and settle
    await tester.pumpAndSettle();

    // Verify that the Contract of Discipline is shown
    expect(find.text('CONTRACT OF DISCIPLINE'), findsOneWidget);
  });
}
