import 'dart:math' as math;

class SensorUtils {
  static const double gravity = 9.81;

  static bool isSignificantTilt(
    double x,
    double y,
    double z, {
    double threshold = 3.0,
  }) {
    final magnitude = math.sqrt(x * x + y * y + z * z);
    final delta = (magnitude - gravity).abs();
    return delta > threshold || x.abs() > threshold || y.abs() > threshold;
  }

  static bool isPickupMotion(double x, double y, double z) {
    final magnitude = math.sqrt(x * x + y * y + z * z);
    final delta = (magnitude - gravity).abs();
    final horizontalMotion = math.sqrt(x * x + y * y);
    return delta > 2.0 && horizontalMotion > 1.5;
  }
}
