import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:sneak_peak/pages/admin%20screens/theme%20page/admin_theme_page.dart';
import 'package:sneak_peak/pages/user%20screens/settings%20page/settings_page.dart';
import 'package:sneak_peak/routes/go_router.dart';
import 'package:sneak_peak/services/local%20notification%20service/loca_notification_service.dart';
import 'package:sneak_peak/utils/android_notificatons_channels.dart';
int getShortUniqueId() {
  int bigId = DateTime.now().microsecondsSinceEpoch;
  int shortId = bigId % 100000; // Last 5 digits
  return shortId;
}
class FirebaseNotificationsService {
  

 static void showFireaseNotification(BuildContext context,  ) async {
    FirebaseMessaging.onMessage.listen((message) {
      LocalNotificationService.showNotification(
        
        message.notification?.title ?? '',
        message.notification?.body ?? '',
        MyAndroidNotificatonsChannels.mediumImporatnce,
        playload: message.notification?.title
      );
    });
  }

  static Future<void> permission() async {
    var messaging = FirebaseMessaging.instance;
     await messaging
        .requestPermission(
          alert: true,
          announcement: true,
          badge: true,
          carPlay: true,
          criticalAlert: true,
          providesAppNotificationSettings: true,
          provisional: true,
          sound: true,
        );

    // if (notificationSettings.authorizationStatus ==
    //     AuthorizationStatus.authorized) {
    //   print('TIN TIN NOTI Android');
    // } else if (notificationSettings.authorizationStatus ==
    //     AuthorizationStatus.provisional) {
    //   print('TIN TIN NOTI Ios');
    // } else {
    //   AppSettings.openAppSettings(type: AppSettingsType.notification);
    //   print('ON THE NOTI');
    // }
  }

 static Future<String> getToken() async {
    var messaging = FirebaseMessaging.instance;
    var token = await messaging.getToken();

    return token ?? '';
  }

static void onBackgroundNotification(){

 FirebaseMessaging.onMessageOpenedApp.listen((message) {
  AppGoRouter.goRouter.pushNamed(SettingsPage.pageName);
});
}


static Future<void> onKilledApp()async{

 RemoteMessage? initialMessage = 
      await FirebaseMessaging.instance.getInitialMessage();
      
  if (initialMessage != null) {
    AppGoRouter.goRouter.pushNamed(ThemePage.pageName);
  }

}

}
