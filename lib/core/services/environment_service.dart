import 'package:battery_plus/battery_plus.dart';

class EnvironmentService {
  final Battery _battery;

  EnvironmentService({Battery? battery}) : _battery = battery ?? Battery();

  bool isNightHours() {
    final hour = DateTime.now().hour;
    return hour >= 22 || hour < 5;
  }

  Future<int> getBatteryLevel() async {
    try {
      final level = await _battery.batteryLevel;
      return level;
    } catch (_) {
      return -1;
    }
  }

  Future<bool> isLowBattery() async {
    final level = await getBatteryLevel();
    return level != -1 && level < 20;
  }
}
