import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// PROVIDERS
import '../../providers/devil_provider.dart';
import '../../providers/focus_provider.dart';

// WIDGETS
import 'widgets/devil_nav_bar.dart';
import 'widgets/eye_widget.dart';
import 'widgets/habit_list.dart';
import 'widgets/contract_sheet.dart';
import 'widgets/background_video.dart';
import 'widgets/reckoning_overlay.dart'; // THE NEW AUDIT OVERLAY

// SCREEN IMPORTS
import '../focus/focus_screen.dart';
import '../mirror/mirror_screen.dart';
import '../profile/profile_screen.dart';
import 'widgets/soul_ledger_screen.dart';
import '../../widgets/ambient_particles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Handles navigation with haptic feedback and page sync
  void _onTabTapped(int index) {
    if (_currentIndex == index) return;
    HapticFeedback.selectionClick();
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch the Devil's Realm for dynamic accent colors (Heaven/Hell/Void)
    // Watch both providers for dynamic content and navigation locking
    final provider = context.watch<DevilProvider>();
    final focusProvider = context.watch<FocusProvider>();
    final realm = provider.currentRealm;

    final accentColor = realm == "HEAVEN"
        ? Colors.amberAccent
        : (realm == "HELL" ? Colors.redAccent : Colors.grey[400]!);

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent, // Background Video visibility
      body: Stack(
        children: [
          // LAYER 0: THE ABYSSAL BACKGROUND (Video/Atmosphere)
          const BackgroundVideo(),

          // LAYER 0.5: AMBIENT PARTICLES
          AmbientParticles(realm: realm, color: accentColor),

          // LAYER 1: READABILITY VIGNETTE
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.9),
                    Colors.transparent,
                    Colors.black.withOpacity(0.95),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // LAYER 2: MULTI-PAGE CONTENT ENGINE
          PageView(
            controller: _pageController,
            physics:
                const NeverScrollableScrollPhysics(), // Controlled via Nav Bar
            children: [
              _buildLedgerPage(context, accentColor),
              const FocusScreen(),
              const MirrorScreen(),
              const ProfileScreen(),
            ],
          ),

          // LAYER 3: THE DAILY RECKONING (Takeover Overlay)
          // This will blur the entire screen if hasFacedReckoning is false
          const ReckoningOverlay(),
        ],
      ),

      // CUSTOM NAVIGATION (Hidden during focus mode lock-in)
      bottomNavigationBar: focusProvider.isRunning
          ? null
          : DevilNavBar(
              currentIndex: _currentIndex,
              onTap: _onTabTapped,
            ),

      // FAB: Only visible on the Ledger (Home) tab when not focusing
      floatingActionButton: (_currentIndex == 0 && !focusProvider.isRunning)
          ? _buildFAB(accentColor)
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  /// THE PRIMARY TAB: Displaying the Pact Ledger and the All-Seeing Eye
  Widget _buildLedgerPage(BuildContext context, Color accentColor) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          _buildAppBar(context, accentColor),
          const SizedBox(height: 10),
          const DevilEye(),
          const SizedBox(height: 20),
          const Expanded(
            child: HabitList(), // Scrollable list of active contracts
          ),
        ],
      ),
    );
  }

  /// Custom Symmetrical Header with History Portal
  Widget _buildAppBar(BuildContext context, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 40), // Balance Spacer
          Text(
            "THE LEDGER",
            style: GoogleFonts.cinzel(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 6,
              shadows: [
                Shadow(color: accentColor.withOpacity(0.5), blurRadius: 10),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.menu_book_rounded,
              color: accentColor.withOpacity(0.4),
              size: 24,
            ),
            onPressed: () {
              HapticFeedback.mediumImpact();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SoulLedgerScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// FAB for signing new contracts with high-impact haptics
  Widget _buildFAB(Color accentColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Container(
        height: 65,
        width: 65,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          elevation: 0,
          shape: CircleBorder(
            side: BorderSide(color: accentColor.withOpacity(0.3), width: 1.5),
          ),
          onPressed: () {
            HapticFeedback.heavyImpact();
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (context) => const ContractSheet(),
            );
          },
          child: Icon(Icons.add, color: accentColor, size: 30),
        ),
      ),
    );
  }
}
