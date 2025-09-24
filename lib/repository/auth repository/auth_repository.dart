import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sneak_peak/models/auth_modal.dart';
import 'package:sneak_peak/services/auth%20service/auth_service.dart';
import 'package:sneak_peak/services/shared%20pref%20service/shared_pref_service.dart';
import 'package:sneak_peak/services/user%20services/user_cloud_DB_services.dart';

class AuthRepository{

final UserCloudDbServices cloudDbServices;
final AuthService authService;

AuthRepository({required this.authService, required this.cloudDbServices});


Future<String> decidePage()async{
  try {
    return await authService.decidePageCondition();
  }on FirebaseAuthException catch (e) {
    throw Exception(e.code);
  }
}

Future<void> createAccount(AuthModal authModel, String password)async{
try {
  
  var uid= await authService.createAccount(authModel.email, password);
  await cloudDbServices.createAccount(authModel, uid);
}on FirebaseAuthException catch (e) {
  throw Exception(e.code);
}
}

 Future<({String email, String name})> getNameAndEmail()async{
   try {
     return await authService.getNameAndEmail();
   }on FirebaseAuthException catch (e) {
     throw Exception(e.code);
   }
  }

Future<bool> login(String email, String password)async{
try {
 var user= await authService.loginAccount(email, password);
 if (user.user!.emailVerified) {
   SPHelper.setDeciding(SPHelper.logged, true);
   return true;
 }else{
  await authService.firebaseAuth.signOut();
  return false;
 }

}on FirebaseAuthException catch (e) {
  throw Exception(e.code);
}
}


Future<void> logout()async{
try {
  await authService.logout();

    await SPHelper.removeNameEmailImgFromSharedPref(SPHelper.userName,SPHelper.email,SPHelper.userImg,);
await SPHelper.setDeciding(SPHelper.logged, false);
}on FirebaseAuthException catch (e) {
  throw Exception(e.code);
}
}


Future<void> forgotPass(String email)async{
try {
  await authService.forgotPass(email);
}on FirebaseAuthException catch (e) {
  throw Exception(e.code);
}
}


Future<void> changePassword(String oldPass, String newPass)async{
try {
  await authService.changePassword(newPass, oldPass);
}on FirebaseAuthException catch (e) {
  throw Exception(e.code);
}
}

Future<void> updateUsername(String newName)async{
  var uid= authService.firebaseAuth.currentUser?.uid;
try {
  await authService.updateUsername(newName);
  await cloudDbServices.updateName(uid!, newName);
  await SPHelper.setString(SPHelper.userName, newName);
}on FirebaseAuthException catch (e) {
  throw Exception(e.code);
}
}

Future<bool> updateEmail(String newEmail, String password)async{
  var uid= authService.firebaseAuth.currentUser?.uid;
  var email= authService.firebaseAuth.currentUser?.email;
try {
   if (newEmail!= email) {
  await authService.updateEmail(newEmail, password);
  await cloudDbServices.updateEmail(newEmail, uid!); 
  return true;
 }else{
  return false;
 }
}on FirebaseAuthException catch (e) {
  throw Exception(e.code);
}
}

Future<void> syncEmailAfterVerification()async{
  await authService.firebaseAuth.currentUser?.reload();
  var uid= authService.firebaseAuth.currentUser?.uid;
  var email= authService.firebaseAuth.currentUser?.email;
try {
await cloudDbServices.syncEmailAfterVerification(uid!, email!);
  
}on FirebaseAuthException catch (e) {
  await SPHelper.setDeciding(SPHelper.logged, false);
  await SPHelper.removeNameEmailImgFromSharedPref(
        SPHelper.userName,
        SPHelper.email,
        SPHelper.userImg,
      );
  throw Exception(e.code);
}
}


Future<AuthModal?> googleSignIn()async{
  // var uid= authService.firebaseAuth.currentUser?.uid;
try {
  var auth= await authService.signInWithGoogle();
await cloudDbServices.createAccount(auth!, auth.id??'');
await SPHelper.setDeciding(SPHelper.logged, true);
await SPHelper.setString(SPHelper.userName, auth.name);
await SPHelper.setString(SPHelper.email, auth.email);
        return auth;
}on GoogleSignInException catch (e) {
  throw Exception(e.code);}
}

}