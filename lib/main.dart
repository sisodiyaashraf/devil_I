import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'data/repositories/story_repository.dart';
import 'presentation/providers/story_provider.dart';

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
          create: (_) => StoryProvider(StoryRepository())..loadStory(),
        ),
      ],
      child: MaterialApp(
        title: 'Whispers',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const Scaffold(
          body: Center(
            child: Text(
              'Whispers',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 20.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
