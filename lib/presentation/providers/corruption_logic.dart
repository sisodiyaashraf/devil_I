import '../../core/constants.dart';
import '../../domain/entities/story_choice.dart';

int calculateCorruption(int current, StoryChoice choice) {
  final gain = choice.isDark
      ? AppConstants.darkChoiceCorruptionGain
      : AppConstants.lightChoiceCorruptionGain;
  final total = current + gain;
  return total.clamp(0, AppConstants.maxCorruptionLevel);
}
