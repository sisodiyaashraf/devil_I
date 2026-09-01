import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whispers/core/services/audio_service.dart';
import 'package:whispers/data/repositories/ending_repository.dart';
import 'package:whispers/data/repositories/save_repository.dart';
import 'package:whispers/data/repositories/story_repository.dart';
import 'package:whispers/domain/entities/story_node.dart';
import 'package:whispers/presentation/providers/story_provider.dart';
import 'package:whispers/presentation/screens/home_screen.dart';

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

class MockEndingRepository extends EndingRepository {
  final Set<String> unlocked;
  MockEndingRepository([this.unlocked = const {}]);

  @override
  Future<Set<String>> getUnlockedEndingIds() async => unlocked;

  @override
  Future<void> recordEnding(String nodeId) async => unlocked.add(nodeId);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

  testWidgets('HomeScreen displays title, chapter tile, and endings counter', (WidgetTester tester) async {
    final storyRepo = MockStoryRepository();
    final saveRepo = MockSaveRepository();
    final endingRepo = MockEndingRepository();
    final provider = StoryProvider(storyRepo, MockAudioService(), saveRepo, endingRepo);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<StoryProvider>.value(
          value: provider,
          child: const HomeScreen(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();

    expect(find.text('WHISPERS'), findsOneWidget);
    expect(find.text('The House Above'), findsOneWidget);
    expect(find.text('Endings Found'), findsOneWidget);
  });
}
