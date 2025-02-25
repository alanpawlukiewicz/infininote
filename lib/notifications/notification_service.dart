import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

//There is currently no IOS support

class NotificationService {
  static final flutterLocalNotificationPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> onDidReceiveNotification(
      NotificationResponse notificationResponse) async {
    await flutterLocalNotificationPlugin.cancel(notificationResponse.id!);
  }

  static Future<void> init() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('ic_stat_logo_transparent');
    ;

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
    );

    await flutterLocalNotificationPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotification,
    );
  }

  static Future<void> checkForNotificationLaunch() async {
    final details =
        await flutterLocalNotificationPlugin.getNotificationAppLaunchDetails();

    if (details?.didNotificationLaunchApp ?? false) {
      onDidReceiveNotification(details!.notificationResponse!);
    }
  }

  static Future<void> showInstantNotification(String title, String body) async {
    const NotificationDetails platformChannelSpecific = NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channel_Name',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );
    await flutterLocalNotificationPlugin.show(
      0,
      title,
      body,
      platformChannelSpecific,
    );
  }

  static Future<bool> checkNotificationPermission() async {
    final androidPlugin =
        flutterLocalNotificationPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    return await androidPlugin?.areNotificationsEnabled() ?? false;
  }

  static Future<bool> scheduleNotification(
      String title, String body, DateTime scheduledDate) async {
    //ask for permissions
    await flutterLocalNotificationPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    bool isGranted = await checkNotificationPermission();

    if (!isGranted) {
      return false;
    }
    const NotificationDetails platformChannelSpecific = NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channel_Name',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    int id = Random().nextInt(2000000);
    await flutterLocalNotificationPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      platformChannelSpecific,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      payload: scheduledDate.minute.toString().length == 1
          ? '${scheduledDate.hour}:0${scheduledDate.minute}, ${DateFormat.yMMMd().format(scheduledDate)}'
          : '${scheduledDate.hour}:${scheduledDate.minute}, ${DateFormat.yMMMd().format(scheduledDate)}',
    );

    return true;
  }
}
