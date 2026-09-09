import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin;

  static const List<Map<String, String>> _messages = [
    {'title': 'System Process', 'body': 'I noticed you left.'},
    {'title': 'Telemetry Alert', 'body': 'Still there?'},
    {'title': 'ECHO Service', 'body': 'Come back.'},
    {'title': 'Background Task', 'body': 'The connection has not ended.'},
  ];

  NotificationService({FlutterLocalNotificationsPlugin? plugin})
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    try {
      tz.initializeTimeZones();
      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _plugin.initialize(initSettings).timeout(
        const Duration(seconds: 3),
        onTimeout: () => false,
      );

      _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission()
          .timeout(const Duration(seconds: 2), onTimeout: () => null)
          .catchError((_) => null);

      _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true)
          .timeout(const Duration(seconds: 2), onTimeout: () => null)
          .catchError((_) => null);
    } catch (_) {}
  }

  Future<void> scheduleUnsettlingNotification({bool enabled = true}) async {
    if (!enabled) return;
    try {
      await cancelScheduled();

      final random = Random();
      final message = _messages[random.nextInt(_messages.length)];
      final delayHours = 2 + random.nextInt(5); // 2 to 6 hours
      final scheduledDate =
          tz.TZDateTime.now(tz.local).add(Duration(hours: delayHours));

      const androidDetails = AndroidNotificationDetails(
        'echo_scares',
        'System Notifications',
        channelDescription: 'ECHO system alert notifications',
        importance: Importance.high,
        priority: Priority.high,
      );
      const iosDetails = DarwinNotificationDetails();
      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _plugin.zonedSchedule(
        0,
        message['title'],
        message['body'],
        scheduledDate,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (_) {}
  }

  Future<void> showPersistentPresenceNotice({bool enabled = true}) async {
    if (!enabled) return;
    try {
      const androidDetails = AndroidNotificationDetails(
        'echo_presence',
        'Background Presence',
        channelDescription: 'ECHO background status indicator',
        importance: Importance.low,
        priority: Priority.low,
        ongoing: true,
        autoCancel: false,
      );
      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentSound: false,
      );
      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _plugin.show(
        999,
        'ECHO',
        'running',
        details,
      );
    } catch (_) {}
  }

  Future<void> clearPersistentPresenceNotice() async {
    try {
      await _plugin.cancel(999);
    } catch (_) {}
  }

  Future<void> cancelScheduled() async {
    try {
      await _plugin.cancelAll();
    } catch (_) {}
  }
}
