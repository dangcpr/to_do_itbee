import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest_all.dart' as tz;
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;
import 'package:to_do_itbee/core/router.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('mipmap/launcher_icon');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestSoundPermission: false,
          requestBadgePermission: false,
          requestAlertPermission: false,
        );
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
          macOS: initializationSettingsDarwin,
          linux: initializationSettingsLinux,
        );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onTapNotification,
      onDidReceiveBackgroundNotificationResponse: onTapNotificationBack,
    );

    // open notification when the app is terminated
    final NotificationAppLaunchDetails? details =
        await _flutterLocalNotificationsPlugin
            .getNotificationAppLaunchDetails();

    if (details?.didNotificationLaunchApp ?? false) {
      onTapNotificationBack(details!.notificationResponse!);
    }

    //initialize timezone
    tz.initializeTimeZones();

    //grant permission for local notification
    final status = await Permission.notification.status;
    if (status != PermissionStatus.granted &&
        status != PermissionStatus.restricted) {
      await Permission.notification.request();
    }

    final exactTimeStatus = await Permission.scheduleExactAlarm.status;
    if (exactTimeStatus != PermissionStatus.granted &&
        exactTimeStatus != PermissionStatus.restricted) {
      await Permission.scheduleExactAlarm.request();
    }
  }

  static Future<void> onTapNotification(
    NotificationResponse notificationResponse,
  ) async {
    if (notificationResponse.payload == null ||
        notificationResponse.payload == '') {
      return;
    }
    final payload = jsonDecode(notificationResponse.payload.toString());
    if (payload['type'] == 'due_dates') {
      goRouter.goNamed(
        'update',
        pathParameters: {'id': payload['id'].toString()},
      );
    }
  }

  @pragma('vm:entry-point')
  static Future<void> onTapNotificationBack(
    NotificationResponse notificationResponse,
  ) async {
    onTapNotification(notificationResponse);
  }

  Future<void> scheduleNotification(
    int id, {
    String? title = "Due Date",
    String? body,
    String? payload,
    required DateTime scheduledDate,
  }) async {
    try {
      DateTime scheduledDateUTC = scheduledDate.toUtc();
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
            '123',
            'To Do Dang',
            channelDescription: 'To Do Dang',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
          );
      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
      );

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDateUTC, tz.local),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }
}
