import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MyAndroidNotificatonsChannels {
  

  static AndroidNotificationChannel highImporatnce = AndroidNotificationChannel(
    'HIGHT_Importance',
    'Alert Notificatins',
    importance: Importance.high,
    playSound: true,
  );
  static AndroidNotificationChannel lowImporatnce = AndroidNotificationChannel(
    'LOW_Importance',
    'Update Notiations',
    importance: Importance.low,
    playSound: true,
  );
  static AndroidNotificationChannel mediumImporatnce =
      AndroidNotificationChannel(
        'Medium_Importance',
        'New arrived products notifications',
        importance: Importance.max,
        playSound: true,

      );




}