import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whispers/core/constants.dart';
import 'package:whispers/core/services/audio_service.dart';
import 'package:whispers/data/repositories/save_repository.dart';
import 'package:whispers/data/repositories/story_repository.dart';
import 'package:whispers/domain/entities/story_choice.dart';
import 'package:whispers/domain/entities/story_node.dart';
import 'package:whispers/presentation/providers/story_provider.dart';
import 'package:whispers/presentation/widgets/mute_toggle_button.dart';

class MockSaveRepository implements SaveRepository {
  @override
  Future<void> saveProgress(String nodeId, int corruptionLevel) async {}

  @override
  Future<Map<String, dynamic>?> loadProgress() async => null;

  @override
  Future<void> clearProgress() async {}
}

class TestStoryRepository extends StoryRepository {
  @override
  Future<Map<String, StoryNode>> loadChapter(String assetPath) async {
    return {
      'start': const StoryNode(
        id: 'start',
        text: 'Node 1',
        choices: [
          StoryChoice(label: 'Next', nextNodeId: 'next', isDark: false),
        ],
      ),
      'next': const StoryNode(
        id: 'next',
        text: 'Node 2',
        choices: [],
        soundCue: 'creak',
      ),
    };
  }
}

class MockAudioService implements AudioService {
  bool _isMuted = false;
  String? lastStingCue;
  int playAmbientCount = 0;
  int loadMuteStateCount = 0;

  @override
  bool get isMuted => _isMuted;

  @override
  Future<void> loadMuteState() async {
    loadMuteStateCount++;
  }

  @override
  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
  }

  @override
  Future<void> playAmbient() async {
    playAmbientCount++;
  }

  @override
  Future<void> stopAmbient() async {}

  @override
  Future<void> playSting(String? cueKey) async {
    lastStingCue = cueKey;
  }

  @override
  Future<void> playJumpscare() async {}

  @override
  Future<void> playAlarm() async {}
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

  test('AudioService manages state and preferences correctly', () async {
    SharedPreferences.setMockInitialValues({
      AppConstants.muteKey: true,
    });

    final audioService = AudioService();
    await audioService.loadMuteState();
    expect(audioService.isMuted, isTrue);

    await audioService.toggleMute();
    expect(audioService.isMuted, isFalse);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool(AppConstants.muteKey), isFalse);
  });

  testWidgets('MuteToggleButton displays correct icon and toggles state', (WidgetTester tester) async {
    final audioService = MockAudioService();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MuteToggleButton(audioService: audioService),
        ),
      ),
    );

    // Initial state: unmuted (should display volume_up)
    expect(find.byIcon(Icons.volume_up), findsOneWidget);
    expect(find.byIcon(Icons.volume_off), findsNothing);

    // Tap to mute
    await tester.tap(find.byType(MuteToggleButton));
    await tester.pump();

    // State: muted (should display volume_off)
    expect(find.byIcon(Icons.volume_off), findsOneWidget);
    expect(find.byIcon(Icons.volume_up), findsNothing);
  });

  test('StoryProvider triggers audio loading and stings', () async {
    final repository = TestStoryRepository();
    final audioService = MockAudioService();
    final provider = StoryProvider(repository, audioService, MockSaveRepository());

    await provider.loadStory();
    expect(audioService.loadMuteStateCount, 1);
    expect(audioService.playAmbientCount, 1);

    // Select the choice to navigate to next node, which has soundCue: 'creak'
    provider.selectChoice(const StoryChoice(label: 'Next', nextNodeId: 'next', isDark: false));
    expect(audioService.lastStingCue, 'creak');
  });
}
