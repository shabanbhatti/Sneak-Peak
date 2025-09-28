import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sneak_peak/models/auth_modal.dart';
import 'package:sneak_peak/services/notification_service.dart/notification_service.dart';
import 'package:sneak_peak/services/shared%20pref%20service/shared_pref_service.dart';
import 'package:sneak_peak/utils/admin_details.dart';

class AuthService {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;
  final NotificationService notificationService;

  AuthService({
    required this.firebaseAuth,
    required this.googleSignIn,
    required this.notificationService,
  });

  Future<String> createAccount(String email, String password) async {
    var creatingAccount = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,

    );
    // var name= await creatingAccount.user?.updateDisplayName(name);
    await creatingAccount.user!.sendEmailVerification();
    return creatingAccount.user!.uid;
  }

  Future<void> reAuthenticateUser(String password) async {
    var email = firebaseAuth.currentUser!.email;
    print(email);
    print(password);
    await firebaseAuth.currentUser?.reauthenticateWithCredential(
      EmailAuthProvider.credential(email: email!, password: password),
    );
  }

  Future<void> deleteAccount() async {
    await firebaseAuth.currentUser?.delete();
  }

  Future<String> decidePageCondition() async {
    var splash = await SPHelper.getBool(SPHelper.splash);
    var logged = await SPHelper.getBool(SPHelper.logged);

    if (splash) {
      if (logged && firebaseAuth.currentUser != null) {
        if (firebaseAuth.currentUser!.email == adminEmail) {
          return 'admin';
        } else {
          return 'user';
        }
      } else {
        return 'login';
      }
    } else {
      return 'splash';
    }
  }

  Future<UserCredential> loginAccount(String email, String password) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<({String email, String name})> getNameAndEmail() async {
    var name = firebaseAuth.currentUser?.displayName ?? '';
    var email = firebaseAuth.currentUser?.email ?? '';
    return (email: email, name: name);
  }

  Future<void> logout() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
  }

  Future<void> forgotPass(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<AuthModal?> signInWithGoogle() async {
    await GoogleSignIn.instance.initialize(
      serverClientId:
          '225529638875-n21n2ofv75fam4709chdn164jnh4mqk8.apps.googleusercontent.com',
    );

    final GoogleSignInAccount googleSignInAccount =
        await googleSignIn.authenticate();

    GoogleSignInAuthentication googleSignInAuthentication =
        googleSignInAccount.authentication;

    var authCredential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
    );

    var userCredential = await firebaseAuth.signInWithCredential(
      authCredential,
    );

    var fcmToken = await notificationService.getToken();
    AuthModal authModel = AuthModal(
      name: userCredential.user!.displayName!,
      email: userCredential.user!.email!,
      id: userCredential.user?.uid,
      fcmToken: fcmToken,
      createdAtDate: DateTime.now().toString(),
    );

    return authModel;
  }

  Future<void> updateEmail(String newEmail, String password) async {
    var auth = firebaseAuth.currentUser;

    await auth?.reauthenticateWithCredential(
      EmailAuthProvider.credential(email: auth.email!, password: password),
    );

    await auth?.verifyBeforeUpdateEmail(newEmail);
  }

  Future<void> updateUsername(String newName) async {
    var currentUser = firebaseAuth.currentUser;
    await currentUser?.updateDisplayName(newName);
  }

  Future<void> changePassword(String newPass, String oldPass) async {
    var currentUser = firebaseAuth.currentUser;

    await currentUser?.reauthenticateWithCredential(
      EmailAuthProvider.credential(
        email: currentUser.email ?? '',
        password: oldPass,
      ),
    );

    await currentUser?.updatePassword(newPass);
  }
}
