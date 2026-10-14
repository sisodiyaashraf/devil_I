import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/theme.dart';
import '../../data/repositories/memory_repository.dart';
import '../providers/echo_provider.dart';

class CorruptionReportScreen extends StatefulWidget {
  const CorruptionReportScreen({super.key});

  @override
  State<CorruptionReportScreen> createState() => _CorruptionReportScreenState();
}

class _CorruptionReportScreenState extends State<CorruptionReportScreen>
    with SingleTickerProviderStateMixin {
  final ScreenshotController _screenshotController = ScreenshotController();
  int _peakCorruption = 0;
  int _sessionCount = 1;

  late final AnimationController _entranceCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _loadMemoryStats();

    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _fadeAnim = CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0.0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOutCubic));
  }

  Future<void> _loadMemoryStats() async {
    try {
      final repo = MemoryRepository();
      final memory = await repo.loadMemory();
      if (mounted) {
        setState(() {
          _peakCorruption = memory.peakCorruption;
          _sessionCount = memory.sessionCount;
        });
      }
    } catch (_) {}
  }

  String _getDiagnosis(int level) {
    if (level < 30) return 'STATUS: STABLE.\nENTITY DORMANT. NO IMMEDIATE THREAT.';
    if (level <= 70) return 'STATUS: ANOMALIES DETECTED.\nINTERFERENCE INCREASING. MONITOR CLOSELY.';
    return 'STATUS: CONTAINMENT FAILED.\nSYSTEM BREACH IMMINENT. EVACUATE MEMORY.';
  }

  String _getThreatTier(int level) {
    if (level < 30) return 'TIER I';
    if (level <= 70) return 'TIER II';
    return 'TIER III ⚠';
  }

  Future<void> _shareReport(int corruptionLevel) async {
    try {
      final imageBytes = await _screenshotController.capture();
      if (imageBytes == null) return;

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/corruption_report.png').create();
      await file.writeAsBytes(imageBytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'ECHO Telemetry Report — Corruption: $corruptionLevel%',
      );
    } catch (_) {}
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final echo = context.watch<EchoProvider>();
    final corruption = echo.corruptionLevel;
    final diagnosis = _getDiagnosis(corruption);
    final tier = _getThreatTier(corruption);
    final isHigh = corruption >= 60;
    final isMed = corruption >= 30;
    final color = isHigh
        ? AppColors.corruptRed
        : isMed
            ? AppColors.warningAmber
            : AppColors.terminalGreen;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // ── Top header ──────────────────────────────────────
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.staticGray.withValues(alpha: 0.5),
                            ),
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 10.0,
                                color: AppColors.mutedText,
                              ),
                              SizedBox(width: 4.0),
                              Text(
                                'BACK',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 10.0,
                                  color: AppColors.mutedText,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        tier,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11.0,
                          fontWeight: FontWeight.bold,
                          color: color,
                          letterSpacing: 2.0,
                          shadows: neonGlow(color, blur: 8),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20.0),

                  // ── Scrollable report area ───────────────────────────
                  Expanded(
                    child: Screenshot(
                      controller: _screenshotController,
                      child: Container(
                        color: AppColors.background,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              'ECHO // CORRUPTION\nDIAGNOSTIC',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: color,
                                letterSpacing: 2.0,
                                height: 1.3,
                                shadows: neonGlow(color, blur: 12),
                              ),
                            ),
                            const SizedBox(height: 6.0),
                            // Accent divider
                            Container(
                              height: 1.0,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    color.withValues(alpha: 0.8),
                                    color.withValues(alpha: 0.1),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24.0),

                            // Stats
                            _buildStatCard(
                              label: 'CURRENT SESSION CORRUPTION',
                              value: '$corruption%',
                              valueColor: color,
                              glowColor: color,
                              icon: Icons.warning_amber_rounded,
                            ),
                            const SizedBox(height: 10.0),
                            _buildStatCard(
                              label: 'PEAK HISTORICAL CORRUPTION',
                              value: '$_peakCorruption%',
                              valueColor: AppColors.staticGray,
                              glowColor: null,
                              icon: Icons.timeline_rounded,
                            ),
                            const SizedBox(height: 10.0),
                            _buildStatCard(
                              label: 'TOTAL SESSIONS LOGGED',
                              value: '$_sessionCount',
                              valueColor: AppColors.staticGray,
                              glowColor: null,
                              icon: Icons.layers_rounded,
                            ),

                            const SizedBox(height: 24.0),

                            // Diagnosis block
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceElevated,
                                border: Border(
                                  left: BorderSide(
                                      color: color.withValues(alpha: 0.8),
                                      width: 2.0),
                                  top: BorderSide(
                                      color: color.withValues(alpha: 0.15),
                                      width: 1.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: color.withValues(alpha: 0.07),
                                    blurRadius: 20.0,
                                    spreadRadius: 2.0,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '// SYSTEM ASSESSMENT',
                                    style: TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 9.0,
                                      color: color.withValues(alpha: 0.6),
                                      letterSpacing: 2.0,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    diagnosis,
                                    style: TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 13.0,
                                      color: color,
                                      fontWeight: FontWeight.w600,
                                      height: 1.5,
                                      shadows: neonGlow(color, blur: 6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  // ── Action buttons ───────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          label: 'CLOSE',
                          icon: Icons.close_rounded,
                          color: AppColors.staticGray,
                          filled: false,
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: _ActionButton(
                          label: 'SHARE',
                          icon: Icons.share_rounded,
                          color: color,
                          filled: true,
                          onTap: () => _shareReport(corruption),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required Color valueColor,
    required Color? glowColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(2.0),
        border: Border.all(
          color: AppColors.staticGray.withValues(alpha: 0.2),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14.0, color: valueColor.withValues(alpha: 0.6)),
          const SizedBox(width: 10.0),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 10.0,
                color: AppColors.mutedText,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: valueColor,
              shadows: glowColor != null ? neonGlow(glowColor, blur: 8) : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool filled;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.filled,
    required this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        decoration: BoxDecoration(
          color: widget.filled
              ? widget.color.withValues(alpha: _pressed ? 0.35 : 0.15)
              : (_pressed ? AppColors.surfaceElevated : Colors.transparent),
          border: Border.all(
            color: widget.color.withValues(alpha: _pressed ? 1.0 : 0.5),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(2.0),
          boxShadow: _pressed && widget.filled
              ? neonGlow(widget.color, blur: 10)
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, size: 14.0, color: widget.color),
            const SizedBox(width: 6.0),
            Text(
              widget.label,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: widget.color,
                letterSpacing: 1.5,
                shadows: _pressed ? neonGlow(widget.color, blur: 6) : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
