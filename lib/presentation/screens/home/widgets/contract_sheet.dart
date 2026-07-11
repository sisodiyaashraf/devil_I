import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

// RELATIVE IMPORTS: Absolute consistency
import '../../../../presentation/providers/devil_provider.dart';
import 'contract_widgets/ritual_scroller.dart';
import 'contract_widgets/time_selector.dart';
import 'contract_widgets/glass_settings_panel.dart';
import 'contract_widgets/custom_input_field.dart';

class ContractSheet extends StatefulWidget {
  const ContractSheet({super.key});

  @override
  State<ContractSheet> createState() => _ContractSheetState();
}

class _ContractSheetState extends State<ContractSheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _threatController = TextEditingController();
  final FocusNode _vowFocusNode = FocusNode();

  // CONTRACT STATE
  bool _isBloodOath = false;
  int _focusDurationMinutes = 30;
  TimeOfDay? _reminderTime;
  int _warningMinutes = 0;
  String _severity = "MAJOR";

  @override
  void initState() {
    super.initState();
    // Re-render button when text changes to handle validation state
    _titleController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _threatController.dispose();
    _vowFocusNode.dispose();
    super.dispose();
  }

  /// THE FINAL SEAL: Commits the pact and handles haptics
  void _sealPact() {
    if (_titleController.text.trim().isEmpty) {
      HapticFeedback.vibrate(); // Error feedback
      return;
    }

    HapticFeedback.heavyImpact();

    context.read<DevilProvider>().signContract(
      title: _titleController.text.trim(),
      threat: _threatController.text.isEmpty
          ? "THE VOID WAITS."
          : _threatController.text.trim(),
      isBloodOath: _isBloodOath,
      durationSeconds: _focusDurationMinutes * 60,
      reminderTime: _reminderTime,
      warningMinutes: _warningMinutes,
      severity: _isBloodOath ? "MORTAL" : _severity,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final realm = context.watch<DevilProvider>().currentRealm;
    final bool isValid = _titleController.text.trim().isNotEmpty;

    Color accent = realm == "HEAVEN" ? Colors.amberAccent : Colors.redAccent;
    Color border = realm == "HEAVEN" ? Colors.amber[900]! : Colors.red[900]!;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 20,
        right: 20,
        top: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF030303),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
        border: Border(top: BorderSide(color: border, width: 2.5)),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHandle(),
            const SizedBox(height: 15),
            _buildHeader(accent, realm),
            const SizedBox(height: 25),

            RitualScroller(
              accent: accent,
              onSelect: (title, threat) {
                HapticFeedback.selectionClick();
                setState(() {
                  _titleController.text = title;
                  _threatController.text = threat;
                });
              },
            ),

            const SizedBox(height: 30),

            CustomInputField(
              controller: _titleController,
              focusNode: _vowFocusNode,
              label: "The Vow",
              accent: accent,
              border: border,
            ),
            const SizedBox(height: 15),
            CustomInputField(
              controller: _threatController,
              label: "The Consequence",
              accent: accent,
              border: border,
              isSmall: true,
            ),

            const SizedBox(height: 30),

            TimeSelector(
              currentMinutes: _focusDurationMinutes,
              accent: accent,
              onChanged: (val) {
                HapticFeedback.lightImpact();
                setState(() => _focusDurationMinutes = val);
              },
            ),

            const SizedBox(height: 30),

            GlassSettingsPanel(
              accent: accent,
              reminderTime: _reminderTime,
              severity: _severity,
              isBloodOath: _isBloodOath,
              warningMinutes: _warningMinutes,
              onTimePick: (t) => setState(() => _reminderTime = t),
              onSeverityCycle: (s) => setState(() => _severity = s),
              onOathToggle: (v) => setState(() => _isBloodOath = v),
              onWarningCycle: (w) => setState(() => _warningMinutes = w),
            ),

            const SizedBox(height: 40),

            // THE IMPROVED SEAL BUTTON
            _buildFinalSeal(border, accent, isValid),
          ],
        ),
      ),
    );
  }

  // --- UI HELPERS ---

  Widget _buildHandle() => Center(
    child: Container(
      width: 45,
      height: 5,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );

  Widget _buildHeader(Color accent, String realm) => Center(
    child: Text(
      realm == "HEAVEN" ? "ASCENSION VOW" : "BLACK CONTRACT",
      style: GoogleFonts.cinzel(
        color: accent,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacing: 5,
        shadows: [Shadow(color: accent.withOpacity(0.5), blurRadius: 10)],
      ),
    ),
  );

  Widget _buildFinalSeal(Color border, Color accent, bool isValid) => SizedBox(
    width: double.infinity,
    height: 60,
    child: AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isValid ? 1.0 : 0.3, // Fade button if Vow is empty
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: border,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          shadowColor: accent.withOpacity(0.4),
          elevation: isValid ? 15 : 0,
        ),
        onPressed: isValid ? _sealPact : null,
        child: Text(
          _isBloodOath ? "SEAL IN BLOOD" : "INVOKE PACT",
          style: GoogleFonts.cinzel(
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
            fontSize: 14,
          ),
        ),
      ),
    ),
  );
}
