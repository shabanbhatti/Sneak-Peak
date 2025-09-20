import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/services/shared%20pref%20service/shared_pref_service.dart';

final getSharedPrefDataProvider = StateNotifierProvider<GetSpDataStateNotifier, ({String name, String email})>((ref) {
  return GetSpDataStateNotifier();
});

class GetSpDataStateNotifier extends StateNotifier<({String name, String email})> {
  GetSpDataStateNotifier(): super((name: '', email: ''));
  

Future<void> getNameEmailDataFromSP()async{
var db= FirebaseFirestore.instance.collection('users');
var auth = FirebaseAuth.instance.currentUser;

try {
  var email=await SPHelper.getString(SPHelper.email);
var name= await SPHelper.getString(SPHelper.userName);
if (email=='' || name=='') {
  var data= await db.doc(auth!.uid).get();
  String firebaseName= data['name']??'';
  String firebaseEmail= data['email']??'';
state= (name: firebaseName, email: firebaseEmail);
await SPHelper.setString(SPHelper.userName, firebaseName);
await SPHelper.setString(SPHelper.email, firebaseEmail);
}else{
  state=(name: name, email: email);
}

} catch (e) {
  print(e);
  throw Exception(e);
}



}



}