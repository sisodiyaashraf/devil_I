import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// THE FIX: Relative imports to find your message logic
import '../constants/ritual_messages.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInitSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    // THE FIX: Named parameter is 'initializationSettings'
    await _notificationsPlugin.initialize(
      settings:
          initSettings, // You can also use initializationSettings: initSettings
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        debugPrint("Notification tapped: ${details.payload}");
      },
    );

    await _createNotificationChannels();
  }

  Future<void> _createNotificationChannels() async {
    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImplementation != null) {
      const AndroidNotificationChannel reckoningChannel =
          AndroidNotificationChannel(
            'devil_reckoning_channel',
            'Daily Reckoning',
            description: 'Atmospheric reminders of your progress.',
            importance: Importance.max,
          );

      const AndroidNotificationChannel warningChannel =
          AndroidNotificationChannel(
            'devil_task_warning_channel',
            'Pact Deadlines',
            description: 'Urgent alerts for your Blood Oaths.',
            importance: Importance.max,
          );

      await androidImplementation.createNotificationChannel(reckoningChannel);
      await androidImplementation.createNotificationChannel(warningChannel);
    }
  }

  Future<void> requestPermissions() async {
    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidImplementation?.requestNotificationsPermission();
    await androidImplementation?.requestExactAlarmsPermission();
  }

  // --- 1. TASK REMINDER (The 2-Minute Warning) ---
  Future<void> scheduleTaskWarning({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String realm = "VOID",
  }) async {
    if (scheduledTime.isBefore(DateTime.now())) return;

    final urgentTaunt = RitualMessages.getUrgentWarning(realm);

    await _notificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: "$urgentTaunt: $body",
      scheduledDate: tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'devil_task_warning_channel',
          'Pact Deadlines',
          importance: Importance.max,
          priority: Priority.high,
          color: realm == "HEAVEN"
              ? const Color(0xFFFFD700)
              : const Color(0xFFD50000),
          fullScreenIntent: true,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // THE FIX: uiLocalNotificationDateInterpretation is removed in v17+
    );
  }

  // --- 2. THE DAILY RITUAL CYCLE (4 Times Daily) ---
  Future<void> scheduleDailyRitualCycle(String realm) async {
    for (int i = 0; i < 4; i++) {
      await _notificationsPlugin.cancel(id: 100 + i);
    }

    final List<TimeOfDay> scheduleTimes = [
      const TimeOfDay(hour: 9, minute: 0),
      const TimeOfDay(hour: 13, minute: 0),
      const TimeOfDay(hour: 17, minute: 0),
      const TimeOfDay(hour: 21, minute: 0),
    ];

    for (int i = 0; i < scheduleTimes.length; i++) {
      final String message = RitualMessages.getMessage(i, realm);

      await _notificationsPlugin.zonedSchedule(
        id: 100 + i,
        title: realm == "HEAVEN" ? "DIVINE GUIDANCE" : "THE DEVIL'S VOICE",
        body: message,
        scheduledDate: _nextInstanceOfTime(scheduleTimes[i]),
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            'devil_reckoning_channel',
            'Daily Ritual Guidance',
            importance: Importance.high,
            priority: Priority.high,
            color: realm == "HEAVEN"
                ? const Color(0xFFFFD700)
                : const Color(0xFF424242),
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        // THE FIX: uiLocalNotificationDateInterpretation removed here as well
      );
    }
  }

  // --- 3. THE 8:00 PM AUDIT ---
  Future<void> scheduleDailyReckoning(int uncompletedCount) async {
    if (uncompletedCount == 0) {
      await _notificationsPlugin.cancel(id: 0);
      return;
    }

    await _notificationsPlugin.zonedSchedule(
      id: 0,
      title: "THE RECKONING APPROACHES",
      body: "YOU HAVE $uncompletedCount UNFULFILLED VOWS.",
      scheduledDate: _nextInstanceOfTime(const TimeOfDay(hour: 20, minute: 0)),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'devil_reckoning_channel',
          'Daily Reckoning',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      // THE FIX: uiLocalNotificationDateInterpretation removed
    );
  }

  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
