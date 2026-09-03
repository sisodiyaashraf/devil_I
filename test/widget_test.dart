import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whispers/main.dart';

void main() {
  testWidgets('App renders Whispers home screen and navigates to story', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

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

    while (tester.any(find.byType(CircularProgressIndicator))) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    final chapterTile = find.text('CONTAINMENT BREACH THETA');
    expect(chapterTile, findsOneWidget);
    await tester.tap(chapterTile);

    await tester.pump();
    while (tester.any(find.byType(CircularProgressIndicator))) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.textContaining('DEVIL_I'), findsWidgets);
  });
}

