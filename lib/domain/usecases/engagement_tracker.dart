class EngagementTracker {
  int _touchCount = 0;
  int _elapsedSeconds = 0;

  int get touchCount => _touchCount;
  int get elapsedSeconds => _elapsedSeconds;

  void recordTouch() {
    _touchCount++;
  }

  void tick([int seconds = 1]) {
    _elapsedSeconds += seconds;
  }

  double get averageTimeBetweenTouches {
    if (_touchCount <= 1) return _elapsedSeconds.toDouble();
    return _elapsedSeconds / _touchCount;
  }

  double get scareFrequencyMultiplier {
    if (_elapsedSeconds < 5) return 1.0;
    final touchesPerMinute = _touchCount / (_elapsedSeconds / 60.0);
    final multiplier = 0.7 + (touchesPerMinute / 12.0) * 0.8;
    return multiplier.clamp(0.7, 1.5);
  }

  void reset() {
    _touchCount = 0;
    _elapsedSeconds = 0;
  }
}
