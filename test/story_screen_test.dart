import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whispers/core/services/audio_service.dart';
import 'package:whispers/data/repositories/story_repository.dart';
import 'package:whispers/domain/entities/story_choice.dart';
import 'package:whispers/domain/entities/story_node.dart';
import 'package:whispers/presentation/providers/story_provider.dart';
import 'package:whispers/presentation/screens/story_screen.dart';

class MockStoryRepository extends StoryRepository {
  final Map<String, StoryNode> mockNodes;

  MockStoryRepository(this.mockNodes);

  @override
  Future<Map<String, StoryNode>> loadChapter(String assetPath) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return mockNodes;
  }
}

class MockAudioService extends AudioService {
  bool _isMuted = false;

  @override
  bool get isMuted => _isMuted;

  @override
  Future<void> loadMuteState() async {}

  @override
  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
  }

  @override
  Future<void> playAmbient() async {}

  @override
  Future<void> stopAmbient() async {}

  @override
  Future<void> playSting(String? cueKey) async {}
}

void main() {
  late Map<String, StoryNode> testNodes;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    testNodes = {
      'start': const StoryNode(
        id: 'start',
        text: 'A shadow looms over you.',
        choices: [
          StoryChoice(label: 'Run away', nextNodeId: 'escape', isDark: false),
        ],
      ),
      'escape': const StoryNode(
        id: 'escape',
        text: 'You escaped the dark room.',
        choices: [],
      ),
    };
  });

  testWidgets('StoryScreen renders and behaves correctly', (WidgetTester tester) async {
    final repository = MockStoryRepository(testNodes);
    final audioService = MockAudioService();
    final provider = StoryProvider(repository, audioService);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<StoryProvider>.value(
          value: provider..loadStory(),
          child: const StoryScreen(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.pumpAndSettle();
    expect(find.text('A shadow looms over you.'), findsOneWidget);
    expect(find.text('Run away'), findsOneWidget);

    await tester.tap(find.text('Run away'));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('You escaped the dark room.'), findsOneWidget);
    expect(find.text('Run away'), findsNothing);

    expect(find.text('THE END'), findsOneWidget);
    expect(find.text('Start Over'), findsOneWidget);
  });
}
