import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whispers/data/repositories/lore_repository.dart';
import 'package:whispers/data/repositories/memory_repository.dart';
import 'package:whispers/domain/entities/dialogue_fragment.dart';
import 'package:whispers/domain/entities/presence_signal.dart';
import 'package:whispers/domain/usecases/behavior_profile.dart';
import 'package:whispers/domain/usecases/dialogue_composer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BehaviorProfile Tests', () {
    test('Classifies restless pattern when touch or tilt frequency is high', () {
      final profile = BehaviorProfile();
      profile.tick(10);
      for (int i = 0; i < 10; i++) {
        profile.recordTouch();
      }
      expect(profile.currentPattern, equals(BehaviorPattern.restless));
    });

    test('Classifies cautious pattern when idle stretch is long with low touches', () {
      final profile = BehaviorProfile();
      profile.tick(20);
      expect(profile.currentPattern, equals(BehaviorPattern.cautious));
    });

    test('Classifies neutral pattern initially', () {
      final profile = BehaviorProfile();
      profile.tick(2);
      expect(profile.currentPattern, equals(BehaviorPattern.neutral));
    });
  });

  group('DialogueComposer Tests', () {
    final pool = [
      const DialogueFragment(id: 'op1', slot: 'opener', text: 'SYSTEM READY.', minCorruption: 0, tone: 'clipped'),
      const DialogueFragment(id: 'obs1', slot: 'observation', text: 'YOU ARE WATCHED.', minCorruption: 0, tone: 'quiet'),
      const DialogueFragment(id: 'cl1', slot: 'closer', text: 'PROCEED.', minCorruption: 0, tone: 'neutral'),
    ];

    test('compose produces non-empty string and updates usage counts', () {
      final composer = DialogueComposer(random: Random(42));
      final usage = <String, int>{};
      final result = composer.compose(pool, PresenceSignal.idle, 0, BehaviorPattern.neutral, usage);

      expect(result, isNotNull);
      expect(result!.isNotEmpty, isTrue);
      expect(usage.isNotEmpty, isTrue);
    });

    test('compose respects maxUsesPerSession', () {
      final composer = DialogueComposer(random: Random(42));
      final limitedPool = [
        const DialogueFragment(id: 'single', slot: 'opener', text: 'ONCE ONLY.', maxUsesPerSession: 1),
      ];
      final usage = <String, int>{};

      final first = composer.compose(limitedPool, PresenceSignal.idle, 0, BehaviorPattern.neutral, usage);
      expect(first, equals('ONCE ONLY.'));

      final second = composer.compose(limitedPool, PresenceSignal.idle, 0, BehaviorPattern.neutral, usage);
      expect(second, isNull);
    });
  });

  group('LoreRepository & MemoryRepository Tests', () {
    test('MemoryRepository persists and retrieves shown lore', () async {
      SharedPreferences.setMockInitialValues({});
      final memoryRepo = MemoryRepository();

      expect(await memoryRepo.getShownLore(), isEmpty);

      await memoryRepo.markLoreShown('Fragment A');
      final shown = await memoryRepo.getShownLore();

      expect(shown.contains('Fragment A'), isTrue);
    });

    test('LoreRepository filters out already-shown lore', () async {
      final loreRepo = LoreRepository();
      final shown = {'You are not the first node assigned to this frequency.'};
      final picked = await loreRepo.pickUnseenLore(5, shown);

      if (picked != null) {
        expect(shown.contains(picked.text), isFalse);
      }
    });
  });
}
