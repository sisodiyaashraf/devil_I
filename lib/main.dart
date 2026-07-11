import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

// --- SERVICE & PROVIDER IMPORTS ---
import 'core/services/notification_service.dart';
import 'presentation/providers/devil_provider.dart';
import 'presentation/providers/focus_provider.dart';

// --- SCREEN IMPORTS ---
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/onboarding/contract_screen.dart';

void main() async {
  // 1. Mandatory for async initialization
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Core Services (Notifications)
  final notificationService = NotificationService();
  await notificationService.init();

  // 3. Request 2026 critical permissions immediately
  // Exact Alarm is mandatory for the '2-minute warning' logic
  await [Permission.notification, Permission.scheduleExactAlarm].request();

  // 4. Check 'The Gatekeeper' flag (Onboarding status)
  final prefs = await SharedPreferences.getInstance();
  final bool hasSigned = prefs.getBool('has_signed_pact') ?? false;

  // 5. Wake up the Providers
  final devilProvider = DevilProvider();
  final focusProvider = FocusProvider();

  try {
    await devilProvider.initialize();
  } catch (e) {
    debugPrint("CRITICAL SYSTEM FAILURE (DATABASE/ISAR): $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<DevilProvider>.value(value: devilProvider),
        ChangeNotifierProvider<FocusProvider>.value(value: focusProvider),
      ],
      child: DevilIApp(hasSigned: hasSigned),
    ),
  );
}

class DevilIApp extends StatefulWidget {
  final bool hasSigned;
  const DevilIApp({super.key, required this.hasSigned});

  @override
  State<DevilIApp> createState() => _DevilIAppState();
}

class _DevilIAppState extends State<DevilIApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// THE GHOST SYNC: Vigilant monitoring of app lifecycle
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Note: Use read to avoid unnecessary rebuilds during lifecycle changes
    final devil = Provider.of<DevilProvider>(context, listen: false);
    final focus = Provider.of<FocusProvider>(context, listen: false);

    if (state == AppLifecycleState.resumed) {
      // 1. Check if the date changed for Midnight Reset
      devil.initialize();
      // 2. Sync focus timer with real-world drift (Anti-Cheat)
      focus.syncRitualWithDrift(devil);
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      // 3. If they background the app during a Focus session, they fail.
      focus.handleAppBackgrounded(devil);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Devil_I',
      debugShowCheckedModeBanner: false,

      // THE VOID THEME (2026 AMOLED & GLASS OPTIMIZED)
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        canvasColor: Colors.transparent, // Required for Glassmorphism Sheets
        // GLOBAL TYPOGRAPHY
        textTheme: GoogleFonts.spaceMonoTextTheme(
          Theme.of(context).textTheme,
        ).apply(bodyColor: Colors.white, displayColor: Colors.white),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF900000),
          brightness: Brightness.dark,
          surface: const Color(0xFF050505),
          primary: const Color(0xFFB71C1C),
          secondary: Colors.amberAccent,
          error: Colors.redAccent,
        ),

        // --- FIXED: DIALOG THEME DATA ---
        dialogTheme: DialogThemeData(
          backgroundColor: const Color(0xFF0D0D0D).withOpacity(0.9),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: Colors.white10),
          ),
          titleTextStyle: GoogleFonts.cinzel(
            color: const Color(0xFFB71C1C),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle: GoogleFonts.spaceMono(color: Colors.white70),
        ),

        // --- GLASS-COMPATIBLE BOTTOM SHEETS ---
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),

        // SNACKBAR (Vow Notifications)
        snackBarTheme: SnackBarThemeData(
          backgroundColor: const Color(0xFF121212),
          elevation: 0,
          contentTextStyle: GoogleFonts.spaceMono(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.redAccent, width: 0.5),
          ),
        ),
      ),

      // THE JUDGMENT GATE
      home: widget.hasSigned ? const HomeScreen() : const ContractScreen(),
    );
  }
}
