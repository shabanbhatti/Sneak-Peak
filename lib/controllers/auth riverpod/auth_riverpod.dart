import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/auth_modal.dart';
import 'package:sneak_peak/provider/provider_objects.dart';
import 'package:sneak_peak/repository/auth%20repository/auth_repository.dart';
import 'package:sneak_peak/utils/admin_email.dart';

final authProvider =
    StateNotifierProvider.family<AuthStateNotifier, AuthState, String>((
      ref,
      key,
    ) {
      return AuthStateNotifier(
        authRepository: ref.read(authRepositoryProviderObject),
      );
    });

class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;

  AuthStateNotifier({required this.authRepository}) : super(AuthInitialState());

  Future<bool> createAccount(AuthModal authModal, String password) async {
    state = AuthLoadingState();
    try {
      await authRepository.createAccount(authModal, password);

      state = AuthLoadedSuccessfulyState();
      return true;
    } catch (e) {
      state = AuthErrorState(error: e.toString());
      return false;
    }
  }

Future<String> decide()async{
try {
  state = AuthLoadingState();
  var decision= await authRepository.decidePage();
state = AuthLoadedSuccessfulyState();
return decision;
} catch (e) {
  state = AuthErrorState(error: e.toString());
  return e.toString();
}
}

  Future<String> signInGoogle() async {
    state = AuthLoadingState();

    try {
      var user = await authRepository.googleSignIn();
      if (user == null) {
        state = AuthInitialState();

        return 'null';
      } else {
        if (user.email == adminEmail) {
          state = AuthLoadedSuccessfulyState();
          return 'admin';
        } else {
          state = AuthLoadedSuccessfulyState();
          return 'user';
        }
      }
    } catch (e) {
      state = AuthErrorState(error: e.toString());
      return 'error';
    }
  }

  Future<String> loginAccount(String email, String password) async {
    state = AuthLoadingState();

    try {
      var isEmailVerified = await authRepository.login(email, password);
      if (isEmailVerified) {
        if (email == adminEmail) {
          state = AuthLoadedSuccessfulyState();
          return 'admin';
        } else {
          state = AuthLoadedSuccessfulyState();
          return 'user';
        }
      } else {
        state = AuthLoadedSuccessfulyState();
        return 'verify';
      }
    } catch (e) {
      state = AuthErrorState(error: e.toString());
      return 'error';
    }
  }

  Future<bool> updateEmail(String newEmail, String password) async {
    state = AuthLoadingState();

    try {
      await authRepository.updateEmail(newEmail, password);
      state = AuthLoadedSuccessfulyState();
      return true;
    } catch (e) {
      state = AuthErrorState(error: e.toString());
      return false;
    }
  }

  Future<void> syncEmailAfterVerification() async {
    try {
      await authRepository.syncEmailAfterVerification();

      state = AuthLoadedSuccessfulyState();
    } catch (e) {
      state = AuthErrorState(error: e.toString());
    }
  }

  Future<void> updateUsername(String newName) async {
    try {
      state = AuthLoadingState();

      await authRepository.updateUsername(newName);
      state = AuthLoadedSuccessfulyState();
    } catch (e) {
      state = AuthErrorState(error: e.toString());
    }
  }

  Future<bool> changePassword(String newPass, String oldPass) async {
    try {
      state = AuthLoadingState();
      await authRepository.changePassword(oldPass, newPass);
      state = AuthLoadedSuccessfulyState();
      return true;
    } catch (e) {
      state = AuthErrorState(error: e.toString());
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      state = AuthLoadingState();
      await authRepository.logout();

      state = AuthLoadedSuccessfulyState();
      return true;
    } catch (e) {
      state = AuthErrorState(error: e.toString());
      return false;
    }
  }

  Future<bool> forgetPassword(String email) async {
    state = AuthLoadingState();

    try {
      await authRepository.forgotPass(email);
      state = AuthLoadedSuccessfulyState();
      return true;
    } catch (e) {
      state = AuthErrorState(error: e.toString());
      return false;
    }
  }
}

sealed class AuthState {
  const AuthState();
}

class AuthInitialState extends AuthState {
  const AuthInitialState();
}

class AuthLoadingState extends AuthState {
  const AuthLoadingState();
}

class AuthLoadedSuccessfulyState extends AuthState {
  const AuthLoadedSuccessfulyState();
}

class AuthErrorState extends AuthState {
  final String error;
  const AuthErrorState({required this.error});
}
