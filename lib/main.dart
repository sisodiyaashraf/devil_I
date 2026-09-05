import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/services/notification_service.dart';
import 'core/theme.dart';
import 'data/repositories/dialogue_repository.dart';
import 'data/repositories/memory_repository.dart';
import 'data/repositories/save_repository.dart';
import 'domain/usecases/presence_detector.dart';
import 'presentation/providers/echo_provider.dart';
import 'presentation/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final notificationService = NotificationService();
  await notificationService.init();
  runApp(EchoApp(notificationService: notificationService));
}

class EchoApp extends StatelessWidget {
  final NotificationService notificationService;

  EchoApp({super.key, NotificationService? notificationService})
      : notificationService = notificationService ?? NotificationService();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => EchoProvider(
            presenceDetector: PresenceDetector(),
            saveRepository: SaveRepository(),
            dialogueRepository: DialogueRepository(),
            memoryRepository: MemoryRepository(),
            notificationService: notificationService,
          )..startSession(),
        ),
      ],
      child: MaterialApp(
        title: 'ECHO',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const MainScreen(),
      ),
    );
  }
}
