import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/provider/provider_objects.dart';
import 'package:sneak_peak/repository/auth%20repository/auth_repository.dart';
import 'package:sneak_peak/services/shared%20pref%20service/shared_pref_service.dart';

final getSharedPrefDataProvider = StateNotifierProvider<GetSpDataStateNotifier, ({String name, String email})>((ref) {
  return GetSpDataStateNotifier(authRepository: ref.read(authRepositoryProviderObject));
});

class GetSpDataStateNotifier extends StateNotifier<({String name, String email})> {
  final AuthRepository authRepository;
  GetSpDataStateNotifier({required this.authRepository}): super((name: '', email: ''));
  

Future<String?> getNameEmailDataFromSP()async{
try {
  var email=await SPHelper.getString(SPHelper.email);
var name= await SPHelper.getString(SPHelper.userName);
if (email=='' || name=='') {
var data= await authRepository.getNameAndEmail();
state= (name: data.name, email: data.email);
await SPHelper.setString(SPHelper.userName, data.name);
await SPHelper.setString(SPHelper.email, data.email);
}else{
  state=(name: name, email: email);
}
return null;
} catch (e) {
  return e.toString();
}



}



}