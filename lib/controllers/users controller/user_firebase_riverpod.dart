import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/pages/admin%20screens/admin_main.dart';
import 'package:sneak_peak/services/user%20services/user_services.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';

final userProvider = StateNotifierProvider<UserStateNotifier, UserState>((ref) {
  return UserStateNotifier();
});

class UserStateNotifier extends StateNotifier<UserState> {
  UserStateNotifier(): super(InitialUserState());
  UserServices userServices = UserServices();

Future<void> updateName(String name, BuildContext context)async{
state= LoadingUserState();
loadingDialog(context, 'Updating name...');
try {
  await userServices.updateName(name);
state=LoadedSuccessfulyUserState();
Navigator.pop(context);
SnackBarHelper.show('Name updated successfuly');
GoRouter.of(context).goNamed(AdminMain.pageName);
SnackBarHelper.show('Name updated successfuly');

} catch (e) {
  state= ErrorUserState();
  Navigator.pop(context);
SnackBarHelper.show('$e');
}


}



}

sealed class UserState{
  const UserState();
}

class InitialUserState extends UserState {
  const InitialUserState();
}

class LoadingUserState extends UserState {
  const LoadingUserState();
}
class LoadedSuccessfulyUserState extends UserState {
  const LoadedSuccessfulyUserState();
}

class ErrorUserState extends UserState {
  const ErrorUserState();
}