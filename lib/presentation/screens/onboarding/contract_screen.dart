import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signature/signature.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home/home_screen.dart';

class ContractScreen extends StatefulWidget {
  const ContractScreen({super.key});

  @override
  State<ContractScreen> createState() => _ContractScreenState();
}

class _ContractScreenState extends State<ContractScreen> {
  final TextEditingController _nameController = TextEditingController();
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black87, // Ink-like color
    exportBackgroundColor: Colors.transparent,
  );

  bool _isSealed = false;

  @override
  void dispose() {
    _nameController.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  Future<void> _sealPact() async {
    final name = _nameController.text.trim();
    if (name.isEmpty || _signatureController.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "PROVIDE YOUR NAME AND SIGNATURE.",
            style: GoogleFonts.spaceMono(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red[900],
        ),
      );
      return;
    }

    setState(() => _isSealed = true);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_signed_pact', true);
    await prefs.setString('user_name', name);

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, anim1, anim2) => const HomeScreen(),
          transitionsBuilder: (context, anim1, anim2, child) =>
              FadeTransition(opacity: anim1, child: child),
          transitionDuration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // Dark desk background
      body: Stack(
        children: [
          // THE PAPER CONTRACT
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFFDFCF0), // Aged Paper / Bone White
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 40,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // THE WAX SEAL ICON
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red[900],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(2, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.shield,
                        color: Color(0xFFC0A060),
                        size: 40,
                      ), // Gold on Red Seal
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "CONTRACT OF DISCIPLINE",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cinzel(
                        color: Colors.black87,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // CONTRACT TEXT
                    Text(
                      "This binding agreement is made between The Void and the undersigned. By entering this domain, you vow to surrender your focus to your tasks without distraction. "
                      "\n\nFailure to comply results in the accumulation of Sins. Success results in Virtues. You acknowledge that your time is a finite resource being wasted by your current habits.",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.notoSerif(
                        color: Colors.black87,
                        fontSize: 13,
                        height: 1.6,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // NAME INPUT
                    TextField(
                      controller: _nameController,
                      style: GoogleFonts.cinzel(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        labelText: "MORTAL NAME",
                        labelStyle: GoogleFonts.cinzel(
                          color: Colors.grey[700],
                          fontSize: 12,
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black26),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // SIGNATURE PAD
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "SIGNATURE:",
                        style: GoogleFonts.cinzel(
                          color: Colors.black87,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 120,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.black, width: 1.5),
                        ),
                      ),
                      child: Signature(
                        controller: _signatureController,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => _signatureController.clear(),
                        child: Text(
                          "RE-SIGN",
                          style: GoogleFonts.spaceMono(
                            color: Colors.red[900],
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // SEAL BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        onPressed: _isSealed ? null : _sealPact,
                        child: Text(
                          "SEAL THE PACT",
                          style: GoogleFonts.cinzel(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // THE STAMP EFFECT
          if (_isSealed)
            Positioned.fill(
              child: Center(
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 5.0, end: 1.0),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  builder: (context, scale, child) {
                    return Transform.scale(scale: scale, child: child);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.red[900]!.withOpacity(0.8),
                        width: 6,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Transform.rotate(
                      angle: -0.2,
                      child: Text(
                        "ACCEPTED",
                        style: GoogleFonts.cinzel(
                          color: Colors.red[900]!.withOpacity(0.8),
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
