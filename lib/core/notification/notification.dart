import 'dart:convert';
import 'dart:typed_data';

import 'package:countdown_apps/clock/presentation/bloc/clock_bloc.dart';
import 'package:countdown_apps/core/di/injection_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nav_router/nav_router.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Notification {
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'Clock_notification_channel',
    'ClockCountDown',
    channelDescription: 'ClockCountDown notification channel',
    importance: Importance.max,
    fullScreenIntent: false,
    visibility: NotificationVisibility.public,
    setAsGroupSummary: true,
    showWhen: true,
    priority: Priority.high,
    ticker: 'ticker',
    channelShowBadge: true,
    enableLights: true,
    enableVibration: true,
    vibrationPattern: Int64List.fromList([0, 500, 100, 150, 50, 150, 50, 500]),
    groupKey: 'ClockCountDown',
    autoCancel: true,
    playSound: true,
    sound: const RawResourceAndroidNotificationSound('ringtone'),
  );

  IOSNotificationDetails iOSPlatformChannelSpecifics =
      const IOSNotificationDetails(
          presentBadge: true,
          presentAlert: true,
          // sound: 'assets/sounds/notif_sound.wav',
          presentSound: true);

  Future<void> initializing() async {
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings(
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);
    await sl<FlutterLocalNotificationsPlugin>()
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    await sl<FlutterLocalNotificationsPlugin>().initialize(
        initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) async {
    return CupertinoAlertDialog(
      title: Text(title ?? ''),
      content: Text(body ?? ''),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true, onPressed: () {}, child: const Text('Okay')),
      ],
    );
  }

  Future onSelectNotification(String? remoteMessage) async {
    Map<String, dynamic> payload = jsonDecode(remoteMessage ?? '');
    sl<ClockBloc>().add(StopCountDownEvent(payload['countDownId'],
        DateTime.now().millisecondsSinceEpoch, 0, null));
  }

  Future<dynamic> scheduleNotification({
    required int countDownId,
    required int countDownTimeInMs,
  }) async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('mipmap/ic_launcher');

    IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification,
            defaultPresentAlert: true,
            defaultPresentBadge: true,
            defaultPresentSound: true);

    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await sl<FlutterLocalNotificationsPlugin>().initialize(
        initializationSettings,
        onSelectNotification: onSelectNotification);

    debugPrint(
        'Schedule Notification ========== ${tz.TZDateTime.fromMillisecondsSinceEpoch(tz.getLocation('Asia/Jakarta'), countDownTimeInMs).toIso8601String()}');

    await sl<FlutterLocalNotificationsPlugin>().zonedSchedule(
      countDownId,
      '🔔🔔🔔 Your CountDown Is Off 🔔🔔🔔',
      'Click this to turn it off',
      tz.TZDateTime.fromMillisecondsSinceEpoch(
          tz.getLocation('Asia/Jakarta'), countDownTimeInMs),
      NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      ),
      payload: jsonEncode({'countDownId': countDownId}),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
