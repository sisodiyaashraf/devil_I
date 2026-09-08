enum BehaviorPattern { restless, cautious, neutral }

class BehaviorProfile {
  int _touchCount = 0;
  int _tiltCount = 0;
  int _currentIdleStretch = 0;
  int _longestIdleStretch = 0;
  int _elapsedSeconds = 0;

  int get touchCount => _touchCount;
  int get tiltCount => _tiltCount;
  int get longestIdleStretch => _longestIdleStretch;
  int get elapsedSeconds => _elapsedSeconds;

  void recordTouch() {
    _touchCount++;
    _currentIdleStretch = 0;
  }

  void recordTilt() {
    _tiltCount++;
  }

  void tick([int seconds = 1]) {
    _elapsedSeconds += seconds;
    _currentIdleStretch += seconds;
    if (_currentIdleStretch > _longestIdleStretch) {
      _longestIdleStretch = _currentIdleStretch;
    }
  }

  double get touchFrequency {
    if (_elapsedSeconds < 1) return 0.0;
    return _touchCount / (_elapsedSeconds / 60.0);
  }

  double get tiltFrequency {
    if (_elapsedSeconds < 1) return 0.0;
    return _tiltCount / (_elapsedSeconds / 60.0);
  }

  BehaviorPattern get currentPattern {
    if (_elapsedSeconds < 5) return BehaviorPattern.neutral;
    if (touchFrequency > 8.0 || tiltFrequency > 5.0) {
      return BehaviorPattern.restless;
    }
    if (_longestIdleStretch >= 15 && touchFrequency < 3.0) {
      return BehaviorPattern.cautious;
    }
    return BehaviorPattern.neutral;
  }

  void reset() {
    _touchCount = 0;
    _tiltCount = 0;
    _currentIdleStretch = 0;
    _longestIdleStretch = 0;
    _elapsedSeconds = 0;
  }
}
