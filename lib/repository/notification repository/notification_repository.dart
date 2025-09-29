import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sneak_peak/models/notifications_model.dart';
import 'package:sneak_peak/services/auth%20service/auth_service.dart';
import 'package:sneak_peak/services/notification_service.dart/notification_service.dart';
import 'package:sneak_peak/services/notification_service.dart/send_notifications_service.dart';
import 'package:sneak_peak/services/user%20services/user_cloud_DB_services.dart';
import 'package:sneak_peak/utils/admin_details.dart';

class NotificationRepository {
  final NotificationService notificationService;
  final SendNotificationsService sendNotificationsService;
  final UserCloudDbServices userServices;
  final AuthService authService;
  NotificationRepository({
    required this.notificationService,
    required this.sendNotificationsService,
    required this.userServices,
    required this.authService,
  });

  Future<void> notificationPermission() async {
    try {
      await notificationService.permission();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    try {
      await notificationService.subsctibeToTopic(topic);
    }on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> sendNotificationsToAll(
    NotificationsModel notificationModel,
  ) async {
    try {
        await sendNotificationsService.sendNotification(
            title: notificationModel.title ?? '',
            body: notificationModel.body ?? '',
            data: {
              'title': notificationModel.metaDataTitle ?? '',
              'body': notificationModel.metaDataBody ?? '',
            },
            isForAll: true
          );
      var uids = await userServices.getAllUsersUid();
      for (var index in uids) {
        String uid = index.uid;
        
        if (uid != adminUid) {
          var id = DateTime.now().microsecondsSinceEpoch;
          log(id.toString());
          log(uid);
          print(id);
          print(uid);
          await userServices.addNotifications(uid, id, notificationModel);

        
        }
      }
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> sendNotificationToSomeone(
    String uid,
    NotificationsModel notificationModel,
  ) async {
    try {
      var id = DateTime.now().microsecondsSinceEpoch;
      await userServices.addNotifications(uid, id, notificationModel);
      var fcmToken = await userServices.getFcmToken(uid);
      
      if (fcmToken != '') {
        
        await sendNotificationsService.sendNotification(
          token: fcmToken,
          title: notificationModel.title ?? '',
          body: notificationModel.body ?? '',
          data: {
            'title': notificationModel.metaDataTitle ?? '',
            'body': notificationModel.metaDataBody ?? '',
          },
        );
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> sendNotification(NotificationsModel notificationModel) async {
    try {
      var uid = authService.firebaseAuth.currentUser!.uid;
      var id = DateTime.now().microsecondsSinceEpoch;
      await userServices.addNotifications(uid, id, notificationModel);
      var fcmToken = await userServices.getFcmToken(uid);
      
      if (fcmToken != '') {
        
        await sendNotificationsService.sendNotification(
          token: fcmToken,
          title: notificationModel.title ?? '',
          body: notificationModel.body ?? '',
          data: {
            'title': notificationModel.metaDataTitle ?? '',
            'body': notificationModel.metaDataBody ?? '',
          },
        );
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> getFcmToken() async {
    try {
      return await notificationService.getToken();
    } catch (e) {
      throw Exception(e);
    }
  }

  void onForegroundNotification(
    void Function(RemoteMessage message) handleRedirection,
  ) async {
    log('fireground in repo');
    try {
      notificationService.firebaseInit(handleRedirection: handleRedirection);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> onBackgroundNotification(
    void Function(RemoteMessage message) handleRedirection,
  ) async {
    log('background in repo');
    try {
      notificationService.onBackgroundNotification(
        handleRedirection: handleRedirection,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> onKilledAppNotifications(
    void Function(RemoteMessage message) handleRedirection,
  ) async {
    log('on killed in repo');
    try {
      await notificationService.onKilledAppNotifications(
        handleRedirection: handleRedirection,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  Stream<List<NotificationsModel>> getNotifications() {
    try {
      String uid = authService.firebaseAuth.currentUser!.uid;
      return userServices.getNotifications(uid);
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> deleteNotifications(String id) async {
    try {
      String uid = authService.firebaseAuth.currentUser!.uid;
      await userServices.deleteNotification(uid, id);
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> deleteAllNotifications() async {
    try {
      String uid = authService.firebaseAuth.currentUser!.uid;
      await userServices.deleteAllNotifications(uid);
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }
}
