
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/Notifications/firebase_notifications_service.dart';
import 'package:sneak_peak/pages/admin%20screens/theme%20page/admin_theme_page.dart';
import 'package:sneak_peak/utils/android_notificatons_channels.dart';



class LocalNotificationService {
 static var notification = FlutterLocalNotificationsPlugin();


  static bool isInitialized = false;


  static Future<void> setupFlutterNotification(BuildContext context) async {
    if (isInitialized) return;


    InitializationSettings initializationSettings = InitializationSettings(
      android: const AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: const DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    );
    
    notification.initialize(initializationSettings,
    onDidReceiveNotificationResponse: (details) {
      if (details.payload=='Alert Notification' ) {
        GoRouter.of(context).pushNamed(ThemePage.pageName);
      }
    },
  
    );
        await notification.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(MyAndroidNotificatonsChannels.highImporatnce);
    await notification
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(MyAndroidNotificatonsChannels.lowImporatnce);
    await notification
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(MyAndroidNotificatonsChannels.mediumImporatnce);
        isInitialized = true;
  }




  static Future<void> showNotification(
    
    String title,
    String body,
    AndroidNotificationChannel androidChannel,
    {String? playload}
  ) async {
    return await notification.show(
      getShortUniqueId(),
      title,
      body,
      payload: playload,
      NotificationDetails(
        android: AndroidNotificationDetails(
          androidChannel.id,
          androidChannel.name,
          icon: "@mipmap/ic_launcher",
          importance: androidChannel.importance,
          priority: Priority.high,
          playSound: androidChannel.playSound,
          

        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  } 
}