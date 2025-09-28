import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sneak_peak/utils/android_notificatons_channels.dart';
import 'package:sneak_peak/utils/short_unique_key._method.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notification;
  final FirebaseMessaging firebaseMessaging;
  NotificationService({
    required this.notification,
    required this.firebaseMessaging,
  });

  Future<void> permission() async {
    try {
      NotificationSettings notificationSettings = await firebaseMessaging
          .requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: true,
            sound: true,
          );

      if (notificationSettings.authorizationStatus ==
          AuthorizationStatus.authorized) {
        if (kDebugMode) print('Notification permission granted');
      } else if (notificationSettings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        if (kDebugMode) print('Provisional notification permission granted');
      } else {
        if (kDebugMode) print('Notification permission denied');
      }
    } catch (e) {
      if (kDebugMode) print('Error requesting permission: $e');
    }
  }

  Future<String> getToken() async {
    var token = await firebaseMessaging.getToken();
    print(token);
    return token ?? '';
  }

  bool isInitialized = false;
  Future<void> initializeLocalNotifications({
    required RemoteMessage remoteMessage,
    required void Function(RemoteMessage remoteMessage) handleRedirection,
  }) async {
    if (isInitialized) return;

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    final InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await notification.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        if (remoteMessage.notification != null &&
            remoteMessage.notification?.title != null) {
          handleRedirection(remoteMessage);
        }
      },
    );

    await _createNotificationChannels();

    isInitialized = true;
  }

  Future<void> _createNotificationChannels() async {
    final androidPlugin =
        notification
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(
        MyAndroidNotificatonsChannels.highImporatnce,
      );
      await androidPlugin.createNotificationChannel(
        MyAndroidNotificatonsChannels.mediumImporatnce,
      );
      await androidPlugin.createNotificationChannel(
        MyAndroidNotificatonsChannels.lowImporatnce,
      );
    }
  }

  void firebaseInit({
    required void Function(RemoteMessage remoteMessage) handleRedirection,
  }) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log('FUCLLLLLLLKKKKKKK');
      if (message.notification != null) {
        await initializeLocalNotifications(
          remoteMessage: message,
          handleRedirection: handleRedirection,
        );
        showNotification(
          message.notification!.title ?? 'New Notification',
          message.notification!.body ?? '',
          MyAndroidNotificatonsChannels.mediumImporatnce,
          payload: message.data.toString(),
        );
      }
    });

    if (Platform.isIOS) {
      iosForegroundNotifications();
    }
  }

  void onBackgroundNotification({
    required void Function(RemoteMessage remoteMessage) handleRedirection,
  }) async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('FUCLLLLLLLKKKKKKK BACKGROUND');
      if (message.notification != null && message.notification?.title != null) {
        handleRedirection(message);
      }
    });
  }

  bool isKilled = false;
  Future<void> onKilledAppNotifications({
    required void Function(RemoteMessage remoteMessage) handleRedirection,
  }) async {
    if (isKilled) return;
    log('FUCLLLLLLLKKKKKKK KILLED');
    await FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message?.notification != null &&
          message?.notification?.title != null &&
          message != null) {
        handleRedirection(message);
      }
    });
  }

  Future<void> iosForegroundNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> showNotification(
    String title,
    String body,
    AndroidNotificationChannel androidChannel, {
    String? payload,
  }) async {
    await notification.show(
      getShortUniqueId(),
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          androidChannel.id,
          androidChannel.name,
          channelDescription: androidChannel.description,
          icon: "@mipmap/ic_launcher",
          importance: androidChannel.importance,
          priority: Priority.high,
          playSound: androidChannel.playSound,
          enableVibration: true,
          sound: androidChannel.sound,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }
}
