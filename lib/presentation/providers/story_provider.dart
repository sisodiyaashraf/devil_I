import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../core/constants.dart';
import '../../core/services/audio_service.dart';
import '../../core/services/haptics_service.dart';
import '../../data/repositories/ending_repository.dart';
import '../../data/repositories/save_repository.dart';
import '../../data/repositories/story_repository.dart';
import '../../domain/entities/ending.dart';
import '../../domain/entities/story_choice.dart';
import '../../domain/entities/story_node.dart';
import 'corruption_logic.dart';

class StoryProvider extends ChangeNotifier {
  final StoryRepository _repository;
  final AudioService _audioService;
  final SaveRepository _saveRepository;
  final EndingRepository _endingRepository;
  final HapticsService _hapticsService;

  Map<String, StoryNode> _allNodes = {};
  List<Ending> _allEndings = [];
  StoryNode? _currentNode;
  final List<String> _history = [];
  int _corruptionLevel = 0;
  bool _isLoading = false;

  StoryProvider(
    this._repository,
    this._audioService,
    this._saveRepository, [
    EndingRepository? endingRepository,
    HapticsService? hapticsService,
  ])  : _endingRepository = endingRepository ?? EndingRepository(),
        _hapticsService = hapticsService ?? HapticsService();

  StoryNode? get currentNode => _currentNode;
  List<String> get history => List.unmodifiable(_history);
  int get corruptionLevel => _corruptionLevel;
  bool get isLoading => _isLoading;
  AudioService get audioService => _audioService;
  EndingRepository get endingRepository => _endingRepository;
  HapticsService get hapticsService => _hapticsService;

  bool get isDeadEnd => _currentNode?.choices.isEmpty ?? true;

  Future<void> loadStory() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _audioService.loadMuteState();
      await _audioService.playAmbient();
      _allNodes = await _repository.loadChapter(AppConstants.chapter1Path);
      final startNode = _allNodes['start'];
      if (startNode != null) {
        _currentNode = startNode;
        _history.clear();
        _history.add(startNode.id);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectChoice(StoryChoice choice) {
    final hapticsEnabled = !_audioService.isMuted;
    if (choice.isDark) {
      _hapticsService.heavyJolt(enabled: hapticsEnabled);
    } else {
      _hapticsService.lightPulse(enabled: hapticsEnabled);
    }

    _corruptionLevel = calculateCorruption(_corruptionLevel, choice);

    final nextNode = _allNodes[choice.nextNodeId];
    if (nextNode != null) {
      _currentNode = nextNode;
      _history.add(nextNode.id);
      if (nextNode.soundCue != null) {
        _audioService.playSting(nextNode.soundCue);
      }
      _saveRepository.saveProgress(nextNode.id, _corruptionLevel);
      if (nextNode.choices.isEmpty) {
        _endingRepository.recordEnding(nextNode.id);
        _hapticsService.doubleBeat(enabled: hapticsEnabled);
      }
    }
    notifyListeners();
  }

  void reset() {
    _history.clear();
    _corruptionLevel = 0;
    _saveRepository.clearProgress();
    final startNode = _allNodes['start'];
    if (startNode != null) {
      _currentNode = startNode;
      _history.add(startNode.id);
    }
    notifyListeners();
  }

  Future<bool> hasSavedProgress() async {
    final progress = await _saveRepository.loadProgress();
    return progress != null;
  }

  Future<void> continueFromSave() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _audioService.loadMuteState();
      await _audioService.playAmbient();
      _allNodes = await _repository.loadChapter(AppConstants.chapter1Path);
      final progress = await _saveRepository.loadProgress();
      if (progress != null) {
        final nodeId = progress['nodeId'] as String;
        final savedNode = _allNodes[nodeId];
        if (savedNode != null) {
          _currentNode = savedNode;
          _history.clear();
          _history.add(nodeId);
          _corruptionLevel = progress['corruptionLevel'] as int;
          if (savedNode.choices.isEmpty) {
            _endingRepository.recordEnding(savedNode.id);
          }
        }
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Set<String>> getUnlockedEndings() {
    return _endingRepository.getUnlockedEndingIds();
  }

  Future<List<Ending>> loadEndingDefinitions() async {
    if (_allEndings.isNotEmpty) return _allEndings;
    final jsonString = await rootBundle.loadString(AppConstants.endingsJsonPath);
    final List<dynamic> jsonList = json.decode(jsonString);
    _allEndings = jsonList.map((e) => Ending.fromJson(e as Map<String, dynamic>)).toList();
    return _allEndings;
  }
}
