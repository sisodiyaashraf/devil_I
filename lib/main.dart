import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/services/audio_service.dart';
import 'core/services/haptics_service.dart';
import 'core/theme.dart';
import 'data/repositories/ending_repository.dart';
import 'data/repositories/save_repository.dart';
import 'data/repositories/story_repository.dart';
import 'presentation/providers/story_provider.dart';
import 'presentation/screens/home_screen.dart';

void main() {
  runApp(const WhispersApp());
}

class WhispersApp extends StatelessWidget {
  const WhispersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => StoryProvider(
            StoryRepository(),
            AudioService(),
            SaveRepository(),
            EndingRepository(),
            HapticsService(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Whispers',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const HomeScreen(),
      ),
    );
  }
}
