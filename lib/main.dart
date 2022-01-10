import 'package:countdown_apps/clock/presentation/pages/clock_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nav_router/nav_router.dart';

import 'clock/presentation/bloc/clock_bloc.dart';
import 'core/di/injection_container.dart' as di;
import 'core/di/injection_container.dart';
import 'core/notification/notification.dart' as notif;

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'count_down_timer_notification_channel',
  'CountDownTimer',
  description: 'CountDownTimer notification channel',
  importance: Importance.max,
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await di
      .sl<FlutterLocalNotificationsPlugin>()
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await di.sl<notif.Notification>().initializing();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ClockBloc>()),
      ],
      child: MaterialApp(
        navigatorKey: navGK,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ClockPages(),
      ),
    );
  }
}
