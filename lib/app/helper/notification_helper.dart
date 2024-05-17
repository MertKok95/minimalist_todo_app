import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationHelper {
  static final _notification = FlutterLocalNotificationsPlugin();

  static init() {
    _notification.initialize(const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings()));

    tz.initializeTimeZones();
  }

  static Future showScheduleNotification(
      {required int id,
      required String title,
      required String body,
      required String payload,
      required DateTime dateTime}) async {
    tz.initializeTimeZones();

    tz.TZDateTime tzDateTime = tz.TZDateTime.from(dateTime, tz.local)
        .add(const Duration(days: -1, minutes: -5));

    // detaylar vepayload kısımı aktif kullanıma geçilmemiştir. Örnektir.
    NotificationDetails notificationDetails = const NotificationDetails(
        android: AndroidNotificationDetails(
            'custom channel name', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker'));

    await _notification.zonedSchedule(
        id, title, body, tzDateTime, notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload);
  }
}
