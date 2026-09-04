import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'data/repositories/save_repository.dart';
import 'domain/usecases/presence_detector.dart';
import 'presentation/providers/echo_provider.dart';

void main() {
  runApp(const EchoApp());
}

class EchoApp extends StatelessWidget {
  const EchoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => EchoProvider(
            presenceDetector: PresenceDetector(),
            saveRepository: SaveRepository(),
          )..startSession(),
        ),
      ],
      child: MaterialApp(
        title: 'ECHO',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const PlaceholderScreen(),
      ),
    );
  }
}

class PlaceholderScreen extends StatefulWidget {
  const PlaceholderScreen({super.key});

  @override
  State<PlaceholderScreen> createState() => _PlaceholderScreenState();
}

class _PlaceholderScreenState extends State<PlaceholderScreen> {
  bool _visible = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (mounted) {
        setState(() => _visible = !_visible);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        context.read<EchoProvider>().registerTouch();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text(
            _visible ? '_' : ' ',
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 32.0,
              color: AppColors.terminalGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
