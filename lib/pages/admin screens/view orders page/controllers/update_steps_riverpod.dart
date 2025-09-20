import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';

final updateStepsProvider = StateNotifierProvider<UpdateStepsNotifier, String>((ref) {
  return UpdateStepsNotifier();
});

class UpdateStepsNotifier extends StateNotifier<String> {
  UpdateStepsNotifier(): super('');
  
Future<void> updateStep(String id,String step ,String uid, BuildContext context )async{

var userDb = FirebaseFirestore.instance.collection('users').doc(uid);
var orderDb = FirebaseFirestore.instance.collection('orders').doc(id);
loadingDialog(context, '', color: Colors.transparent);
try {
  await userDb.collection('to_ship').doc(id).update({'deliveryStatus':step });
  await orderDb.update({'deliveryStatus':step});
  Navigator.pop(context);
}on FirebaseException catch (e) {
  Navigator.pop(context);
  SnackBarHelper.show(e.code, color: Colors.red);
}


}

}