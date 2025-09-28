import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sneak_peak/repository/admin%20repository/product_cloud_db_repository.dart';
import 'package:sneak_peak/repository/auth%20repository/auth_repository.dart';
import 'package:sneak_peak/repository/notification%20repository/notification_repository.dart';
import 'package:sneak_peak/repository/user%20repository/user_cloud_db_repository.dart';
import 'package:sneak_peak/services/admin%20services/product_storage_service.dart';
import 'package:sneak_peak/services/admin%20services/products_cloud_db_service.dart';
import 'package:sneak_peak/services/auth%20service/auth_service.dart';
import 'package:sneak_peak/services/notification_service.dart/notification_service.dart';
import 'package:sneak_peak/services/notification_service.dart/send_notifications_service.dart';
import 'package:sneak_peak/services/user%20services/user_cloud_DB_services.dart';
import 'package:sneak_peak/services/user%20services/user_storage_service.dart';

// Notifications--------------------

final notificationServiceProviderObject = Provider<NotificationService>((ref) {
  return NotificationService(notification: FlutterLocalNotificationsPlugin(), firebaseMessaging: FirebaseMessaging.instance);
});

final notificationRepositoryProviderObject = Provider<NotificationRepository>((ref) {
  return NotificationRepository(notificationService: ref.read(notificationServiceProviderObject), sendNotificationsService: SendNotificationsService(), authService: ref.read(authServiceProviderObject), userServices: ref.read(userCloudDBServiceProviderObject));
});



// Authentications-------------------------

final authServiceProviderObject = Provider<AuthService>((ref) {
  return AuthService(firebaseAuth: FirebaseAuth.instance, googleSignIn: GoogleSignIn.instance, notificationService: ref.read(notificationServiceProviderObject));
});

final authRepositoryProviderObject = Provider<AuthRepository>((ref) {
  return AuthRepository(authService: ref.read(authServiceProviderObject), cloudDbServices: ref.read(userCloudDBServiceProviderObject), notificationService:  ref.read(notificationServiceProviderObject), userStorage: ref.read(userStorageServiceProviderObject));
});

// Users-------------------------

final userCloudDBServiceProviderObject = Provider<UserCloudDbServices>((ref) {
  return UserCloudDbServices(firestore: FirebaseFirestore.instance, firebaseStorage: FirebaseStorage.instance);
});

final userStorageServiceProviderObject = Provider<UserStorageService>((ref) {
  return UserStorageService(firebaseStorage: FirebaseStorage.instance);
});

final userCloudDbRepositoryProvider = Provider<UserCloudDbRepository>((ref) {
  return UserCloudDbRepository(authService: ref.read(authServiceProviderObject), userDbServices: ref.read(userCloudDBServiceProviderObject), userStrgService: ref.read(userStorageServiceProviderObject), notificationService: ref.read(notificationServiceProviderObject));
});

// Products-------------------------

final productServiceProviderObject = Provider<ProductsService>((ref) {
  return ProductsService(firebaseFirestore: FirebaseFirestore.instance, firebaseStorage: FirebaseStorage.instance);
});

final productStorageServiceProviderObject = Provider<ProductStorageService>((ref) {
  return ProductStorageService(firebaseStorage: FirebaseStorage.instance);
});

final productServiceRepositoryProviderObject = Provider<ProductCloudDbRepository>((ref) {
  return ProductCloudDbRepository(productsService: ref.read(productServiceProviderObject), productStorageService: ref.read(productStorageServiceProviderObject));
});