import 'dart:ui';
import 'package:devil_i/presentation/screens/home/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// RELATIVE IMPORTS
import '../../providers/devil_provider.dart';
import 'widgets/identity_portal.dart';
import 'widgets/reaping_heatmap.dart';
import 'widgets/reckoning_summary.dart';
import 'widgets/system_config.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = "ASHRAF";
  String _signedDate = "05/04/2026";

  @override
  void initState() {
    super.initState();
    _loadMortalData();
  }

  /// Pulls the original name from the initial contract signature
  Future<void> _loadMortalData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name')?.toUpperCase() ?? "ASHRAF";
      // Pulling the date the pact was first signed
      _signedDate = prefs.getString('contract_date') ?? "05/04/2026";
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DevilProvider>();
    final realm = provider.currentRealm;
    final score = provider.soulScore;

    // 2026 DYNAMIC ACCENTS
    Color glowColor = realm == "HEAVEN"
        ? Colors.amberAccent
        : (realm == "HELL" ? Colors.redAccent : Colors.cyanAccent);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // LAYER 1: AMBIENT ABYSS (The background glow)
          _buildAtmosphericGlow(glowColor),

          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // THE TOP LABEL
                _buildHeader(glowColor),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // 1. IDENTITY & RANK (Wrapped in Glass)
                      _buildProfileSection(
                        IdentityPortal(
                          userName: _userName,
                          signedDate: _signedDate,
                          glowColor: glowColor,
                          soulScore: score,
                          realm: realm,
                        ),
                        glowColor,
                      ),

                      const SizedBox(height: 24),

                      // 2. RECKONING SUMMARY (24h Snapshot)
                      _buildProfileSection(
                        ReckoningSummary(
                          provider: provider,
                          glowColor: glowColor,
                        ),
                        glowColor,
                      ),

                      const SizedBox(height: 24),

                      // 3. REAPING HEATMAP (30-Day Ledger)
                      _buildProfileSection(
                        ReapingHeatmap(
                          history: provider.history,
                          glowColor: glowColor,
                        ),
                        glowColor,
                      ),

                      const SizedBox(height: 32),

                      // 4. SYSTEM CONFIGURATION (Toggles)
                      const SystemConfig(),

                      const SizedBox(height: 24),

                      // 5. THE GRAVEYARD (Archive)
                      _buildGraveyardButton(glowColor),

                      const SizedBox(height: 120), // Bottom Nav Buffer
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- UI BUILDING BLOCKS ---

  Widget _buildAtmosphericGlow(Color accent) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.6),
            radius: 1.2,
            colors: [accent.withOpacity(0.12), Colors.black],
          ),
        ),
      ),
    );
  }

  /// Helper to wrap profile features in your V2 Glass Engine
  Widget _buildProfileSection(Widget child, Color accent) {
    return GlassCard(
      accentColor: accent,
      blur: 20,
      opacity: 0.08,
      padding: const EdgeInsets.all(20),
      child: child,
    );
  }

  Widget _buildHeader(Color glowColor) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Center(
          child: Text(
            "MORTAL RECORD",
            style: GoogleFonts.cinzel(
              color: glowColor.withOpacity(0.5),
              letterSpacing: 8,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGraveyardButton(Color accent) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      child: OutlinedButton.icon(
        icon: Icon(
          Icons.shield_outlined,
          size: 16,
          color: accent.withOpacity(0.3),
        ),
        onPressed: () {
          // Navigator.push to GraveyardScreen
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.white.withOpacity(0.05)),
          padding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor: Colors.white.withOpacity(0.01),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        label: Text(
          "ENTER THE GRAVEYARD",
          style: GoogleFonts.spaceMono(
            color: Colors.white24,
            letterSpacing: 4,
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}
