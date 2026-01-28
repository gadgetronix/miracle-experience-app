import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;


import '../basic_features.dart';
import '../firebase/push_notification_entity.dart';

/// 🔔 Background handler for FCM
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  logger.i("📩 Background FCM received: ${message.data}");
}

class NotificationManager {
  NotificationManager._();
  static final NotificationManager instance = NotificationManager._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Call ONCE from main()
  Future<void> init() async {
    await _requestPermissions();
    await setupTimezone();
    await _initLocalNotifications();
    await fetchFcmTokenIfNeeded();
    _configureFirebaseListeners();
  }


Future<void> setupTimezone() async {
  tzdata.initializeTimeZones();

  final deviceTimeZone =
      await FlutterTimezone.getLocalTimezone();

  tz.setLocalLocation(tz.getLocation(deviceTimeZone.identifier));

  logger.i("🕒 Device TZ set to: ${tz.local.name}");
}


  /* ───────────── PERMISSIONS ───────────── */

  Future<void> _requestPermissions() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /* ───────────── LOCAL NOTIFICATIONS ───────────── */

  Future<void> _initLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();

    const settings = InitializationSettings(android: android, iOS: ios);

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload == null) return;

        final model = PushNotificationEntity.fromJson(
          jsonDecode(response.payload!),
        );
        _handleNotificationTap(model);
      },
    );
  }

  /* ───────────── FIREBASE LISTENERS ───────────── */

  void _configureFirebaseListeners() {
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleOpenedMessage);

    _messaging.getInitialMessage().then((message) {
      if (message != null) _handleOpenedMessage(message);
    });
  }

  /* ───────────── MESSAGE HANDLERS ───────────── */

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    if (message.notification == null) return;

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      message.notification!.title,
      message.notification!.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'push_channel',
          'Push Notifications',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  void _handleOpenedMessage(RemoteMessage message) {
    if (message.data.isEmpty) return;
    final model = PushNotificationEntity.fromJson(message.data);
    _handleNotificationTap(model);
  }

  void _handleNotificationTap(PushNotificationEntity model) {
    logger.i("📲 Notification tapped: $model");
    // TODO: Add navigation logic here
  }

//   Future<void> testImmediateNotification() async {
//   await _localNotifications.show(
//     999,
//     'TEST',
//     'If you see this, notifications are working',
//     const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'test_channel',
//         'Test Channel',
//         importance: Importance.max,
//         priority: Priority.high,
//       ),
//       iOS: DarwinNotificationDetails(),
//     ),
//   );
// }

  /* ───────────── FCM Tokem ───────────── */

  Future<void> fetchFcmTokenIfNeeded() async {
  String? savedToken = SharedPrefUtils.getFcmToken();
  if (savedToken.isNullOrEmpty()) {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await SharedPrefUtils.setFcmToken(token);
        logger.i("FCM token saved: $token");
        // Optional: sync with backend or OfflineSyncCubit
      }
    } catch (e) {
      logger.w("⚠️ Failed to fetch FCM token, will retry later: $e");
    }
  } else{
    logger.d('FCM token:  $savedToken');
  }
}


  /* ───────────── OFFLINE SYNC REMINDER ───────────── */

//   Future<void> scheduleOfflineSyncReminder({int minutesFromNow = 1}) async {
//   await cancelOfflineSyncReminder();
//   await setupTimezone();
//   // final now = tz.TZDateTime.now(tz.local);
//   final scheduledTime = tz.TZDateTime.from(
//   DateTime.now().add(Duration(minutes: minutesFromNow)),
//   tz.local,
// );

//   const androidDetails = AndroidNotificationDetails(
//     'offline_sync_channel',
//     'Offline Sync Reminder',
//     channelDescription: 'Reminds user to connect internet to sync data',
//     importance: Importance.high,
//     priority: Priority.high,
//     playSound: true,
//   );

//   const iosDetails = DarwinNotificationDetails(
//     presentAlert: true,
//     presentBadge: true,
//     presentSound: true,
//   );

//   await _localNotifications.zonedSchedule(
//     _offlineReminderId,
//     'Sync Pending',
//     'Please connect to the internet to sync your data.',
//     scheduledTime,
//     const NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     ),
//     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//     payload: '{}',
//   );

//   logger.i("🕒 Local TZ: ${tz.local.name}");


//   logger.w("⏰ Offline sync reminder scheduled for $scheduledTime");
// }



  // Future<void> cancelOfflineSyncReminder() async {
  //   await _localNotifications.cancel(_offlineReminderId);
  //   logger.i("✅ Offline sync reminder cancelled");
  // }


//   Future<void> showExactAlarmExplanationDialog(BuildContext context) async {
//   final hasPermission = await hasExactAlarmPermission();
//   if (hasPermission) return;

//   await showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (_) {
//       return AlertDialog(
//         title: const Text('Allow Precise Reminders'),
//         content: const Text(
//           'We need precise reminders to notify you when '
//           'your data is pending sync — even if the app is closed.\n\n'
//           'Without this, reminders may be delayed.',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Not now'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               Navigator.pop(context);
//               await requestExactAlarmPermission();
//             },
//             child: const Text('Allow'),
//           ),
//         ],
//       );
//     },
//   );
// }


// Future<void> requestExactAlarmPermission() async {
//   if (!Platform.isAndroid) return;

//   final androidPlugin =
//       _localNotifications.resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>();

//   await androidPlugin?.requestExactAlarmsPermission();
// }

// Future<bool> hasExactAlarmPermission() async {
//   if (!Platform.isAndroid) return true;

//   final androidPlugin =
//       _localNotifications.resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>();

//   return await androidPlugin?.canScheduleExactNotifications() ?? false;
// }


}

