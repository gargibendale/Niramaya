import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

// Top-level function to handle background notifications
void onBackgroundNotificationResponse(
    NotificationResponse notificationResponse) {
  // Handle the background notification response here
}

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings("@mipmap/ic_launcher");

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestSoundPermission: true,
        requestBadgePermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse:
          onBackgroundNotificationResponse,
    );
  }

  notificationDetails(
      {required String channel_id, required String channel_name}) {
    return NotificationDetails(
        android: AndroidNotificationDetails(channel_id, channel_name,
            importance: Importance.max, priority: Priority.max),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      required String channel_id,
      required String channel_name}) async {
    return notificationsPlugin.show(
        id,
        title,
        body,
        await notificationDetails(
            channel_id: channel_id, channel_name: channel_name));
  }

  Future scheduleNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payLoad,
      required String channel_id,
      required String channel_name,
      required DateTime scheduledNotificationDateTime}) async {
    tz.initializeTimeZones();
    print(tz.TZDateTime.now(tz.getLocation('Asia/Kolkata')));
    if (scheduledNotificationDateTime
        .isBefore(tz.TZDateTime.now(tz.getLocation('Asia/Kolkata')))) {
      scheduledNotificationDateTime =
          scheduledNotificationDateTime.add(const Duration(days: 1));
    }
    return notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(
            scheduledNotificationDateTime, tz.getLocation('Asia/Kolkata')),
        await notificationDetails(
            channel_id: channel_id, channel_name: channel_name),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
