import 'package:flutter_riverpod/flutter_riverpod.dart';

final genderSelectionProvider = StateNotifierProvider.autoDispose<GenderSelectionNotifier, Set<String>>((ref) {
  return GenderSelectionNotifier();
});


class GenderSelectionNotifier extends StateNotifier<Set<String>> {
  GenderSelectionNotifier(): super({});

  
Future<void> addGenders(String gender)async{

state= {...state, gender};
print(state);
}



Future<void> deleteGender(String gender)async{

Set<String> mySet= state.where((element) => element!=gender,).toSet();
state=mySet;
print(state);
}

}