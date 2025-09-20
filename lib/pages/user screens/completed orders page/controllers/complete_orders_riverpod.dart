import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';

final completedOrderProvider = StateNotifierProvider.family<ComletedOrdersNotifier, String, String>((ref, id) {
  return ComletedOrdersNotifier();
});

class ComletedOrdersNotifier extends StateNotifier<String> {
  ComletedOrdersNotifier(): super('');
  

Future<void> deleteCompletedOrder(String id, BuildContext context )async{
var auth= FirebaseAuth.instance.currentUser;
var db= FirebaseFirestore.instance.collection('users').doc(auth!.uid);
loadingDialog(context, 'Deleting...');
try {
  await db.collection('to_ship').doc(id).delete();
  Navigator.pop(context);
}on FirebaseException catch (e) {
  Navigator.pop(context);
  SnackBarHelper.show(e.code, color: Colors.red);
}

}

}