import 'package:flutter_test/flutter_test.dart';
import 'package:whispers/core/services/audio_service.dart';
import 'package:whispers/data/repositories/story_repository.dart';
import 'package:whispers/domain/entities/story_choice.dart';
import 'package:whispers/domain/entities/story_node.dart';
import 'package:whispers/presentation/providers/story_provider.dart';

class MockStoryRepository extends StoryRepository {
  final Map<String, StoryNode> mockNodes;

  MockStoryRepository(this.mockNodes);

  @override
  Future<Map<String, StoryNode>> loadChapter(String assetPath) async {
    return mockNodes;
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

void main() {
  late Map<String, StoryNode> testNodes;

  setUp(() {
    testNodes = {
      'start': const StoryNode(
        id: 'start',
        text: 'You stand in a dark corridor.',
        choices: [
          StoryChoice(label: 'Walk forward', nextNodeId: 'corridor_end', isDark: false),
          StoryChoice(label: 'Listen closely', nextNodeId: 'bedroom_trap', isDark: true),
        ],
      ),
      'corridor_end': const StoryNode(
        id: 'corridor_end',
        text: 'The corridor ends at a heavy door.',
        choices: [],
      ),
      'bedroom_trap': const StoryNode(
        id: 'bedroom_trap',
        text: 'A shadow looms.',
        choices: [],
      ),
    };
  });

  test('StoryProvider initial state and loading', () async {
    final repository = MockStoryRepository(testNodes);
    final provider = StoryProvider(repository, MockAudioService());

    expect(provider.isLoading, isFalse);
    expect(provider.currentNode, isNull);
    expect(provider.corruptionLevel, 0);

    final Future<void> loadFuture = provider.loadStory();
    expect(provider.isLoading, isTrue);

    await loadFuture;
    expect(provider.isLoading, isFalse);
    expect(provider.currentNode?.id, 'start');
    expect(provider.history, ['start']);
    expect(provider.isDeadEnd, isFalse);
  });

  test('StoryProvider selectChoice and corruption updates', () async {
    final repository = MockStoryRepository(testNodes);
    final provider = StoryProvider(repository, MockAudioService());
    await provider.loadStory();

    provider.selectChoice(provider.currentNode!.choices[0]);
    expect(provider.currentNode?.id, 'corridor_end');
    expect(provider.corruptionLevel, 3);
    expect(provider.history, ['start', 'corridor_end']);
    expect(provider.isDeadEnd, isTrue);

    provider.reset();
    expect(provider.currentNode?.id, 'start');
    expect(provider.corruptionLevel, 0);
    expect(provider.history, ['start']);

    provider.selectChoice(provider.currentNode!.choices[1]);
    expect(provider.currentNode?.id, 'bedroom_trap');
    expect(provider.corruptionLevel, 12);
    expect(provider.history, ['start', 'bedroom_trap']);
  });
}
