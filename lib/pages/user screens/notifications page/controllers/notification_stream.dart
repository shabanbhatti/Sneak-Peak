import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/notifications_model.dart';
import 'package:sneak_peak/provider/provider_objects.dart';
import 'package:sneak_peak/repository/notification%20repository/notification_repository.dart';


final notificationStreamProvider = StreamProvider<List<NotificationsModel>>((ref)  {
  NotificationRepository userRepo= ref.read(notificationRepositoryProviderObject);
  return userRepo.getNotifications();
});