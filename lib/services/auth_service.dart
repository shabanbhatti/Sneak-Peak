import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sneak_peak/models/auth_modal.dart';
import 'package:sneak_peak/pages/initial%20pages/splash_page.dart';
import 'package:sneak_peak/services/shared%20pref%20service/shared_pref_service.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';

class AuthService {
  Future<void> createAccount(AuthModal authModal, String password) async {
    var auth = FirebaseAuth.instance;
    var db = FirebaseFirestore.instance.collection('users');

    var creatingAccount = await auth.createUserWithEmailAndPassword(
      email: authModal.email,
      password: password,
    );

    await creatingAccount.user!.sendEmailVerification();
    SnackBarHelper.show(
      'Verification link has been sent to your email (check spam folder).',
      duration: const Duration(seconds: 10),
    );
    await db
        .doc(creatingAccount.user!.uid)
        .set(authModal.toMap(creatingAccount.user!.uid));
        await SPHelper.setString(SPHelper.userName, authModal.name);
        await SPHelper.setString(SPHelper.email, authModal.email);
  }

  Future<UserCredential> loginAccount(String email, String password) async {
    var auth = FirebaseAuth.instance;

    return await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout()async{

var auth= FirebaseAuth.instance;

await auth.signOut();

await SPHelper.deleteString(SPHelper.email);
await SPHelper.deleteString(SPHelper.userName);
await SPHelper.setDeciding(SPHelper.logged, false);


  }

  Future<void> forgotPass(String email)async{
var auth = FirebaseAuth.instance;

await auth.sendPasswordResetEmail(email: email);


  }

  Future<UserCredential?> signInWithGoogle() async {
    await GoogleSignIn.instance.initialize(
      serverClientId:
          '225529638875-n21n2ofv75fam4709chdn164jnh4mqk8.apps.googleusercontent.com',
    );

   try {
      GoogleSignIn? googleSignIn = GoogleSignIn.instance;

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.authenticate();


if (googleSignInAccount==null) {
  print('if called');
  return null;
}else{

    GoogleSignInAuthentication? googleSignInAuthentication =
        googleSignInAccount.authentication;




    var authCredential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
    );

    var userCredential = await FirebaseAuth.instance.signInWithCredential(
      authCredential,
    );

    AuthModal authModal = AuthModal(
      name: userCredential.user!.displayName!,
      email: userCredential.user!.email!,
      createdAtDate: DateTime.now().toString(),
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set(authModal.toMap(userCredential.user!.uid));
         await SPHelper.setString(SPHelper.userName, authModal.name);
        await SPHelper.setString(SPHelper.email, authModal.email);
    return userCredential;
}


   } catch (e) {
     print('$e---------------------------------------------');
     return null;
   }
  }


Future<void> updateEmail(String newEmail, String password)async{
  var auth= FirebaseAuth.instance.currentUser;
var db= FirebaseFirestore.instance.collection('users').doc(auth!.uid);

await auth.reauthenticateWithCredential(EmailAuthProvider.credential(email: auth.email??'', password: password));


if (newEmail!=auth.email) {
  await auth.verifyBeforeUpdateEmail(newEmail);

  await db.update({'pending_email': newEmail});

  SnackBarHelper.show('We have sent verification link to your new email, please verifify', duration: const Duration(seconds: 10));

}else{
  SnackBarHelper.show('Email already exist.', color: Colors.red);
}


}




  Future<void> syncEmailAfterVerification(BuildContext context) async {
      
  FirebaseFirestore db = FirebaseFirestore.instance;

    
      await FirebaseAuth.instance.currentUser!.reload();

      final user = FirebaseAuth.instance.currentUser;

      if (user != null && user.email != null) {
        await db.collection('users').doc(user.uid).update({
          'email': user.email,
          'pending_email': FieldValue.delete(),
        });
        await SPHelper.setString(SPHelper.email, user.email??'');
       
      }
    
  }


Future<void> updateUsername(String newName)async{

var auth= FirebaseAuth.instance.currentUser;

var db= FirebaseFirestore.instance.collection('users').doc(auth?.uid);

if (newName!=auth?.displayName) {
  await auth?.updateDisplayName(newName);

  await db.update({
'name': newName
  });

  await SPHelper.setString(SPHelper.userName, newName);
  SnackBarHelper.show('Name update successfuly.');
}else{
  SnackBarHelper.show('This name already a username of this account.', color: Colors.red);
}
}


Future<void> changePassword(String newPass, String oldPass)async{

var auth= FirebaseAuth.instance.currentUser;

await auth?.reauthenticateWithCredential(EmailAuthProvider.credential(email: auth.email??'', password: oldPass));

if (newPass!=oldPass) {
  await auth?.updatePassword(newPass);
  SnackBarHelper.show('Password change successfully');
}else{
  SnackBarHelper.show('Both password should not be same.', color: Colors.red);
}


}


}
