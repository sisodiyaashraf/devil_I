import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whispers/main.dart';

void main() {
  testWidgets('App renders Whispers story screen and starting node text', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    // Mock audioplayers platform channels
    const globalChannel = MethodChannel('xyz.luan/audioplayers.global');
    const playerChannel = MethodChannel('xyz.luan/audioplayers');

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(globalChannel, (MethodCall methodCall) async {
      return null;
    });

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(playerChannel, (MethodCall methodCall) async {
      return null;
    });

    await tester.pumpWidget(const WhispersApp());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for the StartScreen checking phase to finish
    while (tester.any(find.byType(CircularProgressIndicator))) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    // Verify we are on StartScreen and tap the BEGIN button
    final beginButton = find.text('BEGIN');
    expect(beginButton, findsOneWidget);
    await tester.tap(beginButton);

    // Wait for loadStory to trigger another progress indicator and complete loading
    await tester.pump();
    while (tester.any(find.byType(CircularProgressIndicator))) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    // Fast-forward 3 seconds to complete the RevealingText character reveal animation
    await tester.pump(const Duration(seconds: 3));

    // Pump another 500ms to let the ChoiceButton entry delay timers (up to 150ms) complete
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.textContaining('floorboards'), findsOneWidget);
  });
}
