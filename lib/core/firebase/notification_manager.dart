
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../basic_features.dart';
import '../firebase/push_notification_entity.dart';





class NotificationManager {
  bool iosNotify = false;

  init() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission();
    //App foreground
    FirebaseMessaging.onMessage.listen(
          (RemoteMessage message) async {
        logger.w('p.runtimeType=map=onMessage=> ${message.toMap()}');
        print('p.runtimeType=map=onMessage=> ${message.toMap()}');
        logger.w('p.runtimeType=data=onMessage=> ${message.data}');
        if (!iosNotify) {
          // MyApp.notificationVisible.value = true;
          if(message.notification!=null) {
            await showNotification(message.notification?.title ?? "",
                message.notification?.body ?? "",
                model: PushNotificationEntity.fromJson(message.data));
          } } else {
          iosNotify = false;
        }
      },
    );

    //App background
    FirebaseMessaging.onMessageOpenedApp.listen(
          (RemoteMessage message) {
        logger.e("========onMessageOpenedApp");
        iosNotify = true;
        if (message.data.isNotEmpty) {
        }
      },
    );

    //App kill
    FirebaseMessaging.instance.getInitialMessage().then(
          (RemoteMessage? message) {
        Future.delayed(
          const Duration(seconds: 2),
              () async {
            await Firebase.initializeApp();
            if (message != null) {
              if (message.data.isNotEmpty) {
              }
            }
          },
        );
      },
    );
  }

  PushNotificationEntity getModelFromDataObj(String data) {
    logger.e("message ${data.toString()}");
    PushNotificationEntity model = PushNotificationEntity();
    if (data.isNotEmpty) {
      model = PushNotificationEntity.fromJson(jsonDecode(data));
    }
    return model;
  }

  Future<void> showNotification(title, body,
      {required PushNotificationEntity model}) async {
    var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid =
    const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      // onDidReceiveLocalNotification: (id, title, body, payload) async {},
    );

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        logger.e("message11111> ${notificationResponse.payload}");
      },
    );

    var androidChannelSpecifics = const AndroidNotificationDetails(
      'Notification',
      'App notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      styleInformation: DefaultStyleInformation(true, true),
    );
    var iosChannelSpecifics = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidChannelSpecifics,
      iOS: iosChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title ?? "",
      body ?? "",
      platformChannelSpecifics,
      payload: jsonEncode(model),
    );
  }

  }




