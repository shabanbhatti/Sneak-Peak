import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final shoesSizesProvider = StateNotifierProvider<ShoesSizesStateNotifier, ShoesSizesClass>((ref) {
  return ShoesSizesStateNotifier();
});

class ShoesSizesStateNotifier extends StateNotifier<ShoesSizesClass> {
  ShoesSizesStateNotifier(): super(ShoesSizesClass(allShoesSizes: [], kidzList: [], menList: [], womenList: []));
  

Future<void> addSize(int size)async{

if (size>=23 && size<=35) {
  state= state.copyWith(allShoesSizesX: [], kidzListX: [...state.kidzList,size]);
}else if(size>=42&&size<=46){
state= state.copyWith(allShoesSizesX: [], menListX: [...state.menList,size]);
}else{
  state= state.copyWith(allShoesSizesX: [], womenListX: [...state.womenList,size]);
}

log('Men List: ${state.menList}');
log('kidz List: ${state.kidzList}');
log('Women List: ${state.womenList}');
log('all shoes List: ${state.allShoesSizes}');

// List<int> sizeList= [...state,size];

// state= sizeList;

// log('ADD: $state');

}

Future<void> onRemoveCheck(String gender)async{

if (gender=='Women') {
  state= state.copyWith(womenListX: []);
}else if(gender=='Men'){
  state= state.copyWith(menListX: []);
}else{
  state= state.copyWith(kidzListX: []);
}


}


Future<List<int>> addToSHoesList()async{

state= state.copyWith(allShoesSizesX: [...state.kidzList, ...state.menList, ...state.womenList]);
return state.allShoesSizes;
}

Future<void> removerSize(int size)async{

List<int> remList= state.allShoesSizes.where((element) => element!=size,).toList();

state= state.copyWith(allShoesSizesX: remList);

log('Del: $state');

}



}

class ShoesSizesClass {
  final List<int> womenList;
  final List<int> menList;
  final List<int> kidzList;

  final List<int> allShoesSizes;

  const ShoesSizesClass({required this.allShoesSizes, required this.kidzList, required this.menList, required this.womenList});


ShoesSizesClass copyWith({List<int>? womenListX, List<int>? menListX, List<int>? kidzListX, List<int>? allShoesSizesX}){
return ShoesSizesClass(allShoesSizes: allShoesSizesX?? allShoesSizes, kidzList: kidzListX??kidzList, menList: menListX??menList, womenList: womenListX??womenList);
}

}