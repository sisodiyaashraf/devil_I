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

class _CorruptionReportScreenState extends State<CorruptionReportScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  int _peakCorruption = 0;
  int _sessionCount = 1;

  @override
  void initState() {
    super.initState();
    _loadMemoryStats();
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
    if (level < 30) return 'STATUS: STABLE. ENTITY DORMANT.';
    if (level <= 70) return 'STATUS: ANOMALIES DETECTED. INTERFERENCE INCREASING.';
    return 'STATUS: CONTAINMENT FAILED. SYSTEM BREACH IMMINENT.';
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
  Widget build(BuildContext context) {
    final echo = context.watch<EchoProvider>();
    final corruption = echo.corruptionLevel;
    final diagnosis = _getDiagnosis(corruption);
    final isHigh = corruption >= 60;
    final color = isHigh ? AppColors.corruptRed : AppColors.terminalGreen;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: Screenshot(
                  controller: _screenshotController,
                  child: Container(
                    color: AppColors.background,
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ECHO // CORRUPTION DIAGNOSTIC',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: color,
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        _buildStatRow('CURRENT SESSION CORRUPTION', '$corruption%', color),
                        const SizedBox(height: 12.0),
                        _buildStatRow('PEAK HISTORICAL CORRUPTION', '$_peakCorruption%', AppColors.staticGray),
                        const SizedBox(height: 12.0),
                        _buildStatRow('TOTAL SESSIONS LOGGED', '$_sessionCount', AppColors.staticGray),
                        const SizedBox(height: 28.0),
                        Card(
                          elevation: 2,
                          color: AppColors.surface,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: color.withValues(alpha: 0.5)),
                            borderRadius: BorderRadius.zero,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(
                              diagnosis,
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 13.0,
                                color: color,
                                fontWeight: FontWeight.w600,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.staticGray),
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      ),
                      child: const Text(
                        '[CLOSE]',
                        style: TextStyle(fontFamily: 'monospace', color: Colors.white70),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => _shareReport(corruption),
                      style: FilledButton.styleFrom(
                        backgroundColor: color.withValues(alpha: 0.2),
                        side: BorderSide(color: color),
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      ),
                      child: Text(
                        '[SHARE REPORT]',
                        style: TextStyle(fontFamily: 'monospace', color: color, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontFamily: 'monospace', fontSize: 12.0, color: AppColors.staticGray),
        ),
        Text(
          value,
          style: TextStyle(fontFamily: 'monospace', fontSize: 16.0, fontWeight: FontWeight.bold, color: valueColor),
        ),
      ],
    );
  }
}
