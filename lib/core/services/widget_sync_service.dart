import 'package:home_widget/home_widget.dart';
import 'package:flutter/services.dart';

class WidgetSyncService {
  static const String _widgetName = 'DevilWidget';

  /// Updates the Home Widget with the latest Devil Data
  static Future<void> updateDevilDashboard({
    required String activePact,
    required double soulFrequency,
    required String rank,
  }) async {
    try {
      await HomeWidget.saveWidgetData<String>('activePact', activePact);
      await HomeWidget.saveWidgetData<double>('soulFrequency', soulFrequency);
      await HomeWidget.saveWidgetData<String>('rank', rank);

      // Trigger native refresh
      await HomeWidget.updateWidget(name: _widgetName, iOSName: _widgetName);
    } on PlatformException catch (e) {
      print("Failed to sync with the Void: ${e.message}");
    }
  }

  /// Handles Quick Actions from the Home Screen
  static void handleQuickActions(Function(String) onAction) {
    HomeWidget.initiallyLaunchedFromHomeWidget().then((Uri? uri) {
      if (uri != null) {
        onAction(uri.host); // e.g., 'summon_car'
      }
    });
  }
}
