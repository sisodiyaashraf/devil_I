import 'package:devil_i/presentation/screens/home/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

// RELATIVE IMPORTS
import '../../../../presentation/providers/devil_provider.dart';

class SystemConfig extends StatefulWidget {
  const SystemConfig({super.key});

  @override
  State<SystemConfig> createState() => _SystemConfigState();
}

class _SystemConfigState extends State<SystemConfig> {
  bool _hapticsEnabled = true;
  bool _reckoningEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _hapticsEnabled = prefs.getBool('haptics_enabled') ?? true;
      _reckoningEnabled = prefs.getBool('reckoning_enabled') ?? true;
    });
  }

  Future<void> _toggleHaptics(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('haptics_enabled', value);
    if (value) HapticFeedback.mediumImpact();
    setState(() => _hapticsEnabled = value);
  }

  Future<void> _toggleReckoning(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('reckoning_enabled', value);
    if (_hapticsEnabled) HapticFeedback.selectionClick();
    setState(() => _reckoningEnabled = value);
  }

  @override
  Widget build(BuildContext context) {
    final realm = context.watch<DevilProvider>().currentRealm;
    final accent = realm == "HEAVEN"
        ? Colors.amberAccent
        : (realm == "HELL" ? Colors.redAccent : Colors.cyanAccent);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // HEADER: Using the standardized Cinzel Spacing
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 12),
          child: Text(
            "SYSTEM CONFIGURATION",
            style: GoogleFonts.cinzel(
              color: Colors.white12,
              fontSize: 10,
              letterSpacing: 4,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // THE GLASS PANEL (Utilizing GlassCard V2)
        GlassCard(
          accentColor: accent,
          padding: EdgeInsets.zero, // Remove internal padding for ListTiles
          opacity: 0.08,
          blur: 20,
          child: Column(
            children: [
              // 1. SENSORY ENGINE
              _buildConfigTile(
                icon: Icons.sensors_rounded,
                title: "SENSORY ENGINE",
                subtitle: "HAPTIC FEEDBACK PULSE",
                value: _hapticsEnabled,
                accent: accent,
                onChanged: _toggleHaptics,
              ),

              _buildDivider(),

              // 2. THE RECKONING
              _buildConfigTile(
                icon: Icons.gavel_rounded,
                title: "THE RECKONING",
                subtitle: "DAILY 8:00 PM SOUL AUDIT",
                value: _reckoningEnabled,
                accent: accent,
                onChanged: _toggleReckoning,
              ),

              _buildDivider(),

              // 3. DATA PERSISTENCE
              _buildConfigTile(
                icon: Icons.storage_rounded,
                title: "VOID STORAGE",
                subtitle: "LOCAL LEDGER SYNCING",
                value: true,
                accent: accent,
                onChanged: (_) {}, // Permanent System Toggle
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() => Divider(
    height: 1,
    color: Colors.white.withOpacity(0.05),
    indent: 20,
    endIndent: 20,
  );

  Widget _buildConfigTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Color accent,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: accent.withOpacity(0.6), size: 18),
      ),
      title: Text(
        title,
        style: GoogleFonts.cinzel(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.spaceMono(
          color: Colors.white24,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Switch(
        value: value,
        activeColor: accent,
        activeTrackColor: accent.withOpacity(0.2),
        inactiveThumbColor: Colors.grey[800],
        inactiveTrackColor: Colors.white10,
        onChanged: onChanged,
      ),
    );
  }
}
