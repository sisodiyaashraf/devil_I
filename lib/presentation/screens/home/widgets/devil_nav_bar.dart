import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../providers/devil_provider.dart';

class DevilNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const DevilNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final realm = context.watch<DevilProvider>().currentRealm;

    Color accentColor;
    Color borderColor;

    if (realm == "HEAVEN") {
      accentColor = Colors.amberAccent;
      borderColor = Colors.amber[700]!;
    } else if (realm == "HELL") {
      accentColor = Colors.white;
      borderColor = Colors.red[900]!;
    } else {
      accentColor = Colors.grey[400]!;
      borderColor = Colors.grey[800]!;
    }

    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      margin: EdgeInsets.only(
        left: 16, // Slightly tighter margins for 4 icons
        right: 16,
        bottom: bottomPadding > 0 ? bottomPadding + 10 : 24,
      ),
      height: 90,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // LAYER 1: The Floating Frosted Glass Pill
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withOpacity(0.12),
                    blurRadius: 35,
                    spreadRadius: 2,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: borderColor.withOpacity(0.4),
                        width: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // LAYER 2: The 4 Interactive Icons
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _MorphingNavItem(
                  title: "LEDGER",
                  inactiveIcon: Icons.receipt_long_sharp,
                  activeImagePath: 'assets/icons/devilicon.png',
                  isActive: currentIndex == 0,
                  accentColor: accentColor,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onTap(0);
                  },
                ),
                _MorphingNavItem(
                  title: "THE VOID",
                  inactiveIcon: Icons.hourglass_bottom_sharp,
                  activeImagePath: 'assets/icons/devilicon.png',
                  isActive: currentIndex == 1,
                  accentColor: accentColor,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onTap(1);
                  },
                ),
                _MorphingNavItem(
                  title: "MIRROR",
                  inactiveIcon: Icons.auto_graph_sharp,
                  activeImagePath: 'assets/icons/devilicon.png',
                  isActive: currentIndex == 2,
                  accentColor: accentColor,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onTap(2);
                  },
                ),
                // THE NEW TAB: PROFILE
                _MorphingNavItem(
                  title: "IDENTITY",
                  inactiveIcon: Icons.fingerprint_sharp,
                  activeImagePath:
                      'assets/icons/devilicon.png', // Or a unique profile icon if you have one
                  isActive: currentIndex == 3,
                  accentColor: accentColor,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onTap(3);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MorphingNavItem extends StatelessWidget {
  final String title;
  final IconData inactiveIcon;
  final String activeImagePath;
  final bool isActive;
  final Color accentColor;
  final VoidCallback onTap;

  const _MorphingNavItem({
    required this.title,
    required this.inactiveIcon,
    required this.activeImagePath,
    required this.isActive,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutBack,
            transform: Matrix4.translationValues(0, isActive ? -28 : 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive ? Colors.black : Colors.transparent,
                    border: isActive
                        ? Border.all(
                            color: accentColor.withOpacity(0.5),
                            width: 1.5,
                          )
                        : null,
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: accentColor.withOpacity(0.7),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                            BoxShadow(
                              color: accentColor.withOpacity(0.2),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ]
                        : [],
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    switchInCurve: Curves.easeOutBack,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          final rotateAnim = Tween<double>(
                            begin: -0.15,
                            end: 0.0,
                          ).animate(animation);
                          return RotationTransition(
                            turns: rotateAnim,
                            child: ScaleTransition(
                              scale: animation,
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            ),
                          );
                        },
                    child: isActive
                        ? Image.asset(
                            activeImagePath,
                            key: const ValueKey('devil_image'),
                            width: 32, // Slightly smaller to fit 4 tabs better
                            height: 32,
                            color: accentColor,
                          )
                        : Icon(
                            inactiveIcon,
                            key: const ValueKey('standard_icon'),
                            color: Colors.grey[500],
                            size: 24,
                          ),
                  ),
                ),
                const SizedBox(height: 6),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  style: GoogleFonts.spaceMono(
                    color: isActive ? accentColor : Colors.grey[500],
                    fontSize: isActive ? 10 : 8, // Adjusted for 4-item density
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    letterSpacing: isActive ? 1.5 : 1.0,
                    shadows: isActive
                        ? [Shadow(color: accentColor, blurRadius: 10)]
                        : [],
                  ),
                  child: Text(title),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
