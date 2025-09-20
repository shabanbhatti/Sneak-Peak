import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sneak_peak/services/shared%20pref%20service/shared_pref_service.dart';

class UserServices {


Future<void> updateName(String name)async{
var db= FirebaseFirestore.instance.collection('users');
var auth = FirebaseAuth.instance.currentUser;

await db.doc(auth!.uid).update({
'name': name
});

await SPHelper.setString(SPHelper.userName, name);
}


  
}