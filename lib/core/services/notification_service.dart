import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification click if needed
      },
    );

    // Create high-importance Android Notification Channel
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidImplementation != null) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'parking_reminders',
        'Parking Reminders',
        description: 'Notifications to remind you of your parked vehicle',
        importance: Importance.max,
        enableVibration: true,
        playSound: true,
      );
      await androidImplementation.createNotificationChannel(channel);
    }

    _isInitialized = true;
    await requestPermissions();
  }

  /// Request Notification Permissions (Android 13+ & iOS)
  Future<bool> requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidImplementation != null) {
      final notifGranted = await androidImplementation
          .requestNotificationsPermission();
      await androidImplementation.requestExactAlarmsPermission();
      return notifGranted ?? false;
    }

    final IOSFlutterLocalNotificationsPlugin? iosImplementation =
        _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();

    if (iosImplementation != null) {
      final granted = await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return true;
  }

  /// Schedule a parking reminder
  Future<void> scheduleParkingReminder({
    required int id,
    required String placeName,
    required Duration duration,
  }) async {
    await initialize();
    await requestPermissions();

    final scheduledDate = tz.TZDateTime.now(tz.local).add(duration);

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'parking_reminders',
          'Parking Reminders',
          channelDescription:
              'Notifications to remind you of your parked vehicle',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
          enableVibration: true,
          playSound: true,
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    try {
      await _notificationsPlugin.zonedSchedule(
        id,
        'ParkPin Reminder',
        'Your parking session at $placeName has reached its reminder time of ${duration.inMinutes} minutes.',
        scheduledDate,
        platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (_) {
      try {
        // Fallback to inexact alarm if exact alarm is restricted by system
        await _notificationsPlugin.zonedSchedule(
          id,
          'ParkPin Reminder',
          'Your parking session at $placeName has reached its reminder time of ${duration.inMinutes} minutes.',
          scheduledDate,
          platformDetails,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      } catch (e) {
        // Fallback failed
      }
    }
  }

  /// Show reminder immediately (e.g. when timer hits while app is active)
  Future<void> showReminderNow({
    required int id,
    required String placeName,
    required int minutes,
  }) async {
    await initialize();

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'parking_reminders',
          'Parking Reminders',
          channelDescription:
              'Notifications to remind you of your parked vehicle',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
          enableVibration: true,
          playSound: true,
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _notificationsPlugin.show(
      id,
      'ParkPin Reminder',
      'Your parking session at $placeName has reached its reminder time ($minutes minutes).',
      platformDetails,
    );
  }

  /// Cancel a scheduled parking reminder
  Future<void> cancelReminder(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  /// Cancel all reminders
  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }
}
