import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/notifications_model.dart';
import 'package:sneak_peak/provider/provider_objects.dart';
import 'package:sneak_peak/repository/notification%20repository/notification_repository.dart';
import 'package:sneak_peak/repository/user%20repository/user_cloud_db_repository.dart';

final notificationProvider =
    StateNotifierProvider<NotificationStateNotifier, NotificationState>((ref) {
      return NotificationStateNotifier(
        notificationRepository: ref.read(notificationRepositoryProviderObject),
        userCloudDbRepository: ref.read(userCloudDbRepositoryProvider),
      );
    });

class NotificationStateNotifier extends StateNotifier<NotificationState> {
  final NotificationRepository notificationRepository;
  final UserCloudDbRepository userCloudDbRepository;
  NotificationStateNotifier({
    required this.notificationRepository,
    required this.userCloudDbRepository,
  }) : super(InitialNotification());

  Future<void> notificationPermission() async {
    try {
      state = LoadingNotification();
      await notificationRepository.notificationPermission();
      state = LoadedNotification();
    } catch (e) {
      state = ErrorNotification(error: e.toString());
    }
  }



  Future<bool> sendNotificatonToAll(
    NotificationsModel notificationModel,
  ) async {
    try {
      state = LoadingNotification();
      await notificationRepository.sendNotificationsToAll(notificationModel);
      state = LoadedNotification();
      return true;
    } catch (e) {
      state=InitialNotification();
      log(e.toString());
      return false;
      // d
    }
  }


Future<void> subscribeToTopic(String topic) async {
    try {
      state = LoadingNotification();
      await notificationRepository.subscribeToTopic(topic);
      state = LoadedNotification();
    } catch (e) {
      state = ErrorNotification(error: e.toString());
    }
  }

  Future<void> sendNotificationToSomeone(
    String uid,
    NotificationsModel notificationModel,
  ) async {
    try {
      state = LoadingNotification();
      await notificationRepository.sendNotificationToSomeone(
        uid,
        notificationModel,
      );
      state = LoadedNotification();
    } catch (e) {
      // state = ErrorNotification(error: e.toString());
    }
  }

  Future<void> userSendNotification(
    NotificationsModel notificationModel,
  ) async {
    try {
      state = LoadingNotification();
      await notificationRepository.sendNotification(notificationModel);
      state = LoadedNotification();
    } catch (e) {
      // state = ErrorNotification(error: e.toString());
    }
  }

  Future<bool> deleteNotification(String id) async {
    try {
      state = LoadingNotification();
      await notificationRepository.deleteNotifications(id);
      state = LoadedNotification();
      return true;
    } catch (e) {
      state = ErrorNotification(error: e.toString());
      return false;
    }
  }

  Future<bool> deleteAllNotification() async {
    try {
      state = LoadingNotification();
      await notificationRepository.deleteAllNotifications();
      state = LoadedNotification();
      return true;
    } catch (e) {
      state = ErrorNotification(error: e.toString());
      return false;
    }
  }

  Future<String?> getFcmToken() async {
    try {
      state = LoadingNotification();
      var token = await notificationRepository.getFcmToken();
      state = LoadedNotification();
      return token;
    } catch (e) {
      state = ErrorNotification(error: e.toString());
      return null;
    }
  }

  Future<void> onForegroundNotification(
    void Function(RemoteMessage) handleRedirection,
  ) async {
    try {
      state = LoadingNotification();
      notificationRepository.onForegroundNotification(handleRedirection);
      state = LoadedNotification();
    } catch (e) {
      state = ErrorNotification(error: e.toString());
    }
  }

  Future<void> onBackgroundNotification(
    void Function(RemoteMessage) handleRedirection,
  ) async {
    try {
      state = LoadingNotification();
      notificationRepository.onBackgroundNotification(handleRedirection);
      state = LoadedNotification();
    } catch (e) {
      state = ErrorNotification(error: e.toString());
    }
  }

  Future<void> onKilledAppNotification(
    void Function(RemoteMessage) handleRedirection,
  ) async {
    try {
      state = LoadingNotification();
      notificationRepository.onKilledAppNotifications(handleRedirection);
      state = LoadedNotification();
    } catch (e) {
      state = ErrorNotification(error: e.toString());
    }
  }
}

sealed class NotificationState {
  const NotificationState();
}

class InitialNotification extends NotificationState {
  const InitialNotification();
}

class LoadingNotification extends NotificationState {
  const LoadingNotification();
}

class LoadedNotification extends NotificationState {
  const LoadedNotification();
}

class ErrorNotification extends NotificationState {
  final String error;
  const ErrorNotification({required this.error});
}
