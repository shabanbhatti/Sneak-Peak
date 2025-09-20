

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/Notifications/firebase_notifications_service.dart';
import 'package:sneak_peak/pages/user%20screens/settings%20page/settings_page.dart';
import 'package:sneak_peak/services/local%20notification%20service/loca_notification_service.dart';

class FirebaseNotiPage extends StatefulWidget{
const FirebaseNotiPage({super.key});
static const pageName= 'Firebase_noti';
  @override
  State<FirebaseNotiPage> createState() => FirebaseNotiPageState();
}

class FirebaseNotiPageState extends State<FirebaseNotiPage> {



@override
  void initState() {
    super.initState();
    initializeNotifications();
    FirebaseNotificationsService.permission();
    FirebaseNotificationsService.showFireaseNotification(context);
    FirebaseNotificationsService.onBackgroundNotification();
    FirebaseNotificationsService.getToken().then((value) {
      print(value);
    },);
    
  }

 void onBackground(RemoteMessage remoteMessage)async{



if (remoteMessage.notification?.title=='Alert Notification') {
  GoRouter.of(context).pushNamed(SettingsPage.pageName);
}

}

void initializeNotifications()async{

await LocalNotificationService.setupFlutterNotification(context);

}

@override
Widget build(BuildContext context){
return Scaffold(
body: Center(),
);
}
}