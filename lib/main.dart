import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';

void main() {
  runApp(const EchoApp());
}

class EchoApp extends StatelessWidget {
  const EchoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: const [
        // EchoProvider will be added here in Step 3
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: AnimatedOpacity(
          opacity: _visible ? 1.0 : 0.0,
          duration: Duration.zero,
          child: const Text(
            '_',
            style: TextStyle(
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
