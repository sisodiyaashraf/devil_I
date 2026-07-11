import 'package:isar/isar.dart';

part 'soul_entry.g.dart';

@collection
class SoulEntry {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime timestamp; // When the score was recorded

  late int score; // The soul score at that moment
}
