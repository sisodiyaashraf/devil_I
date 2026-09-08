import 'dart:math';
import '../../domain/entities/dialogue_fragment.dart';
import '../../domain/entities/presence_signal.dart';
import 'behavior_profile.dart';

class DialogueComposer {
  final Random _random;

  DialogueComposer({Random? random}) : _random = random ?? Random();

  String? compose(
    List<DialogueFragment> pool,
    PresenceSignal signal,
    int corruptionLevel,
    BehaviorPattern pattern,
    Map<String, int> usageCounts,
  ) {
    final validPool = pool.where((frag) {
      final matchesSignal =
          frag.requiredSignal == null || frag.requiredSignal == signal;
      final matchesCorruption = frag.minCorruption <= corruptionLevel;
      final uses = usageCounts[frag.id] ?? 0;
      final underLimit = uses < frag.maxUsesPerSession;
      return matchesSignal && matchesCorruption && underLimit;
    }).toList();

    if (validPool.isEmpty) return null;

    final targetTone = switch (pattern) {
      BehaviorPattern.restless => 'clipped',
      BehaviorPattern.cautious => 'quiet',
      BehaviorPattern.neutral => 'neutral',
    };

    final openers = validPool.where((f) => f.slot == 'opener').toList();
    final observations = validPool.where((f) => f.slot == 'observation').toList();

    final candidates1 = [...openers, ...observations];
    if (candidates1.isEmpty) return null;
    final picked1 = _pickWeighted(candidates1, targetTone);

    final candidates2 = validPool.where((f) => f.id != picked1.id && f.slot != picked1.slot).toList();
    DialogueFragment? picked2;
    if (candidates2.isNotEmpty && _random.nextBool()) {
      picked2 = _pickWeighted(candidates2, targetTone);
    }

    usageCounts[picked1.id] = (usageCounts[picked1.id] ?? 0) + 1;
    if (picked2 != null) {
      usageCounts[picked2.id] = (usageCounts[picked2.id] ?? 0) + 1;
    }

    final part1 = picked1.text.trim();
    if (picked2 == null) {
      return part1;
    }
    final part2 = picked2.text.trim();
    return '$part1 $part2';
  }

  DialogueFragment _pickWeighted(List<DialogueFragment> list, String targetTone) {
    final weighted = <DialogueFragment>[];
    for (final frag in list) {
      final weight = (frag.tone == targetTone) ? 3 : 1;
      for (int i = 0; i < weight; i++) {
        weighted.add(frag);
      }
    }
    return weighted[_random.nextInt(weighted.length)];
  }
}
