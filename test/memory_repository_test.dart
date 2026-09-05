import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whispers/data/repositories/memory_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('MemoryRepository loads default values when empty', () async {
    final repo = MemoryRepository();
    final memory = await repo.loadMemory();
    expect(memory.sessionCount, equals(0));
    expect(memory.peakCorruption, equals(0));
    expect(memory.userLabel, isNull);
  });

  test('MemoryRepository recordSessionStart increments count', () async {
    final repo = MemoryRepository();
    await repo.recordSessionStart();
    final memory = await repo.loadMemory();
    expect(memory.sessionCount, equals(1));
  });

  test('MemoryRepository recordPeakCorruption updates only if higher', () async {
    final repo = MemoryRepository();
    await repo.recordPeakCorruption(40);
    var memory = await repo.loadMemory();
    expect(memory.peakCorruption, equals(40));

    await repo.recordPeakCorruption(20);
    memory = await repo.loadMemory();
    expect(memory.peakCorruption, equals(40));

    await repo.recordPeakCorruption(85);
    memory = await repo.loadMemory();
    expect(memory.peakCorruption, equals(85));
  });

  test('MemoryRepository saves and loads userLabel', () async {
    final repo = MemoryRepository();
    await repo.saveUserLabel('Subject-09');
    final memory = await repo.loadMemory();
    expect(memory.userLabel, equals('Subject-09'));
  });
}
