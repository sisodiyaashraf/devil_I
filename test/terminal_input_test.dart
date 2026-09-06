import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whispers/data/repositories/memory_repository.dart';
import 'package:whispers/presentation/providers/echo_provider.dart';
import 'package:whispers/presentation/widgets/terminal_input.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TerminalInput & Memory System Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('MemoryRepository saves and loads user answers correctly', () async {
      final repo = MemoryRepository();
      await repo.saveUserAnswer('userLabel', 'MortalOne');
      await repo.saveUserAnswer('directive', 'Observe and obey');

      final memory = await repo.loadMemory();
      expect(memory.userAnswers['userLabel'], equals('MortalOne'));
      expect(memory.userAnswers['directive'], equals('Observe and obey'));
    });

    test('EchoProvider parses input keywords and updates corruption/memory', () async {
      final memoryRepo = MemoryRepository();
      final provider = EchoProvider(memoryRepository: memoryRepo);

      // Submit name command
      await provider.submitUserInput('I am Nocturne');
      expect(provider.currentLine?.text, contains('HELLO, Nocturne'));

      final memory = await memoryRepo.loadMemory();
      expect(memory.userLabel, equals('Nocturne'));

      // Submit purge command
      await provider.submitUserInput('purge system');
      expect(provider.currentLine?.text, contains('PURGE SEQUENCE EXECUTED'));

      // Submit help command
      await provider.submitUserInput('help');
      expect(provider.currentLine?.text, contains('COMMANDS: STATUS'));
    });

    testWidgets('TerminalInput submits typed text on button tap', (WidgetTester tester) async {
      String? submittedText;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TerminalInput(
              corruptionLevel: 10,
              onSubmit: (val) => submittedText = val,
            ),
          ),
        ),
      );

      final inputFinder = find.byKey(const ValueKey('terminal_input_field'));
      final buttonFinder = find.byKey(const ValueKey('terminal_submit_button'));

      expect(inputFinder, findsOneWidget);
      expect(buttonFinder, findsOneWidget);

      await tester.enterText(inputFinder, 'I am Legion');
      await tester.tap(buttonFinder);
      await tester.pump();

      expect(submittedText, equals('I am Legion'));
    });
  });
}
