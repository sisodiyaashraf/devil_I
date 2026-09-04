import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whispers/core/constants.dart';
import 'package:whispers/core/services/audio_service.dart';
import 'package:whispers/presentation/widgets/mute_toggle_button.dart';

class MockAudioService implements AudioService {
  bool _isMuted = false;
  String? lastStingCue;
  int playAmbientCount = 0;
  int loadMuteStateCount = 0;

  @override
  bool get isMuted => _isMuted;

  @override
  Future<void> loadMuteState() async {
    loadMuteStateCount++;
  }

  @override
  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
  }

  @override
  Future<void> playAmbient() async {
    playAmbientCount++;
  }

  @override
  Future<void> stopAmbient() async {}

  @override
  Future<void> playSting(String? cueKey) async {
    lastStingCue = cueKey;
  }

  @override
  Future<void> playJumpscare() async {}

  @override
  Future<void> playAlarm() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const globalChannel = MethodChannel('xyz.luan/audioplayers.global');
  const playerChannel = MethodChannel('xyz.luan/audioplayers');

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(globalChannel, (MethodCall methodCall) async {
    return null;
  });

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(playerChannel, (MethodCall methodCall) async {
    return null;
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('AudioService manages state and preferences correctly', () async {
    SharedPreferences.setMockInitialValues({
      AppConstants.muteKey: true,
    });

    final audioService = AudioService();
    await audioService.loadMuteState();
    expect(audioService.isMuted, isTrue);

    await audioService.toggleMute();
    expect(audioService.isMuted, isFalse);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool(AppConstants.muteKey), isFalse);
  });

  testWidgets('MuteToggleButton displays correct icon and toggles state', (WidgetTester tester) async {
    final audioService = MockAudioService();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MuteToggleButton(audioService: audioService),
        ),
      ),
    );

    expect(find.byIcon(Icons.volume_up), findsOneWidget);
    expect(find.byIcon(Icons.volume_off), findsNothing);

    await tester.tap(find.byType(MuteToggleButton));
    await tester.pump();

    expect(find.byIcon(Icons.volume_off), findsOneWidget);
    expect(find.byIcon(Icons.volume_up), findsNothing);
  });
}
