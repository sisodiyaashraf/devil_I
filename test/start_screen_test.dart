import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whispers/core/services/audio_service.dart';
import 'package:whispers/data/repositories/save_repository.dart';
import 'package:whispers/data/repositories/story_repository.dart';
import 'package:whispers/domain/entities/story_choice.dart';
import 'package:whispers/domain/entities/story_node.dart';
import 'package:whispers/presentation/providers/story_provider.dart';
import 'package:whispers/presentation/screens/start_screen.dart';

class MockStoryRepository extends StoryRepository {
  @override
  Future<Map<String, StoryNode>> loadChapter(String assetPath) async {
    return {
      'start': const StoryNode(
        id: 'start',
        text: 'Starting story node.',
        choices: [],
      ),
    };
  }
}

class MockAudioService implements AudioService {
  @override
  bool get isMuted => false;
  @override
  Future<void> loadMuteState() async {}
  @override
  Future<void> toggleMute() async {}
  @override
  Future<void> playAmbient() async {}
  @override
  Future<void> stopAmbient() async {}
  @override
  Future<void> playSting(String? cueKey) async {}
}

class MockSaveRepository implements SaveRepository {
  String? savedNodeId;
  int savedCorruption = 0;

  @override
  Future<void> saveProgress(String nodeId, int corruptionLevel) async {
    savedNodeId = nodeId;
    savedCorruption = corruptionLevel;
  }

  @override
  Future<Map<String, dynamic>?> loadProgress() async {
    if (savedNodeId == null) return null;
    return {
      'nodeId': savedNodeId!,
      'corruptionLevel': savedCorruption,
    };
  }

  @override
  Future<void> clearProgress() async {
    savedNodeId = null;
    savedCorruption = 0;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('StartScreen displays Begin option when no save exists', (WidgetTester tester) async {
    final storyRepo = MockStoryRepository();
    final saveRepo = MockSaveRepository();
    final provider = StoryProvider(storyRepo, MockAudioService(), saveRepo);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<StoryProvider>.value(
          value: provider,
          child: const StartScreen(),
        ),
      ),
    );

    // Initial check progress
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 100));

    // After loading check completes, Begin button is shown
    expect(find.text('BEGIN'), findsOneWidget);
    expect(find.text('Step into the dark'), findsOneWidget);
    expect(find.text('CONTINUE'), findsNothing);
    expect(find.text('START OVER'), findsNothing);
  });

  testWidgets('StartScreen displays Continue and Start Over options when save exists', (WidgetTester tester) async {
    final storyRepo = MockStoryRepository();
    final saveRepo = MockSaveRepository()..savedNodeId = 'some_node';
    final provider = StoryProvider(storyRepo, MockAudioService(), saveRepo);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<StoryProvider>.value(
          value: provider,
          child: const StartScreen(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 100));

    // After check completes, Continue and Start Over buttons are shown
    expect(find.text('BEGIN'), findsNothing);
    expect(find.text('CONTINUE'), findsOneWidget);
    expect(find.text('Something remembers where you left off'), findsOneWidget);
    expect(find.text('START OVER'), findsOneWidget);
    expect(find.text('Forget everything'), findsOneWidget);
  });
}
