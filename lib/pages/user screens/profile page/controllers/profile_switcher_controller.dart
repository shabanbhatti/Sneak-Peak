import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/services/shared%20pref%20service/shared_pref_service.dart';

final switcherProvider = StateNotifierProvider<SwitcherStateNotifier, bool>((ref) {
  return SwitcherStateNotifier();
});

class SwitcherStateNotifier extends StateNotifier<bool> {
  SwitcherStateNotifier(): super(true);
  

Future<void> getSwitcher()async{

var value=await SPHelper.getBoolForSwitcher(SPHelper.switcher);

if (value) {
  state= true;
}else{
  state=false;
}

}


Future<void> switchTogeled(bool value)async{

if (value) {
  await SPHelper.setBool(SPHelper.switcher, value);
  state= true;
}else{
  await SPHelper.setBool(SPHelper.switcher, value);
  state= false;
}


}


}