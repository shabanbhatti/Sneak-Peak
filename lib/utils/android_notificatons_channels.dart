import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MyAndroidNotificatonsChannels {
  

  static AndroidNotificationChannel highImporatnce = AndroidNotificationChannel(
    'HIGHT_Importance',
    'Alert noti',
    importance: Importance.high,
    playSound: true,
  );
  static AndroidNotificationChannel lowImporatnce = AndroidNotificationChannel(
    'LOW_Importance',
    'Updates noti',
    importance: Importance.low,
    playSound: true,
  );
  static AndroidNotificationChannel mediumImporatnce =
      AndroidNotificationChannel(
        'Medium_Importance',
        'new item noti',
        importance: Importance.max,
        playSound: true,

      );




}