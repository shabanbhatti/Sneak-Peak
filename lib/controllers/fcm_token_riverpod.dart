import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/provider/provider_objects.dart';
import 'package:sneak_peak/repository/user%20repository/user_cloud_db_repository.dart';
import 'package:sneak_peak/services/shared%20pref%20service/shared_pref_service.dart';

final fcmTokenProvider = StateNotifierProvider<FCMTokenNotifier, String>((ref) {
  return FCMTokenNotifier(userCloudDbRepository: ref.read(userCloudDbRepositoryProvider));
});

class FCMTokenNotifier extends StateNotifier<String> {
  final UserCloudDbRepository userCloudDbRepository;
  FCMTokenNotifier({required this.userCloudDbRepository}): super('init');
  

Future<void> updateFcmTokenInInitState()async{

try {
    state= 'loading';
    var isTrue= await SPHelper.getBoolForSwitcher(SPHelper.switcher);
    log('Sp switcher value: $isTrue');
if (isTrue) {
  await userCloudDbRepository.addFcmToken();
}
  state= 'done';
} catch (e) {
 state= e.toString();
}

}


Future<void> addFcmToken()async{

try {
    state= 'loading';
await userCloudDbRepository.addFcmToken();
  state= 'done';
} catch (e) {
 state= e.toString();
}

}


Future<bool> deleteFcmToken()async{
try {
  state= 'loading';
await userCloudDbRepository.deleteFcmToken();
  state= 'done';
  return true;
} catch (e) {
  state= e.toString();
  return false;
}

}


Future<void> updateFcm()async{

try {
    state= 'loading';
await userCloudDbRepository.updateFcmToken();
  state= 'done';
} catch (e) {
 state= e.toString();
}

}


}