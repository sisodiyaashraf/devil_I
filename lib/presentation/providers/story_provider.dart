import 'package:flutter/foundation.dart';
import '../../core/constants.dart';
import '../../data/repositories/story_repository.dart';
import '../../domain/entities/story_choice.dart';
import '../../domain/entities/story_node.dart';
import 'corruption_logic.dart';

class StoryProvider extends ChangeNotifier {
  final StoryRepository _repository;
  Map<String, StoryNode> _allNodes = {};
  StoryNode? _currentNode;
  final List<String> _history = [];
  int _corruptionLevel = 0;
  bool _isLoading = false;

  StoryProvider(this._repository);

  StoryNode? get currentNode => _currentNode;
  List<String> get history => List.unmodifiable(_history);
  int get corruptionLevel => _corruptionLevel;
  bool get isLoading => _isLoading;

  bool get isDeadEnd => _currentNode?.choices.isEmpty ?? true;

  Future<void> loadStory() async {
    _isLoading = true;
    notifyListeners();

    try {
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
    _corruptionLevel = calculateCorruption(_corruptionLevel, choice);

    final nextNode = _allNodes[choice.nextNodeId];
    if (nextNode != null) {
      _currentNode = nextNode;
      _history.add(nextNode.id);
    }
    notifyListeners();
  }

  void reset() {
    _history.clear();
    _corruptionLevel = 0;
    final startNode = _allNodes['start'];
    if (startNode != null) {
      _currentNode = startNode;
      _history.add(startNode.id);
    }
    notifyListeners();
  }
}
