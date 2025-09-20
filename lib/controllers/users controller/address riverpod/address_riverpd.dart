import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/models/address_modal.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';

final addressProvider = StateNotifierProvider.autoDispose<AddressStateNotifier, AddressState>((ref) {
  return AddressStateNotifier();
});

class AddressStateNotifier extends StateNotifier<AddressState> {
  AddressStateNotifier(): super(InitialAddressState());


Future<void> getAddress()async{
  var auth= FirebaseAuth.instance.currentUser;
var db= FirebaseFirestore.instance.collection('users').doc(auth!.uid);
try {
var address= await db.collection('home_addresses').doc(auth.uid).get();

var data= address.data();
if (data!=null) {
state= LoadedSuccessfulyAddressState(addressModal: AddressModal.fromMap(data));  
}else{
  print('NULL____________________________');
  state= LoadedSuccessfulyAddressState(addressModal: null); 
}

}on FirebaseException catch (e) {
  state= ErrorAddressState(error: e.code);
}

}


Future<void> getAddressFromOrderPage(String uid)async{
var db= FirebaseFirestore.instance.collection('users').doc(uid);
try {
  state= LoadingAddressState();
var address= await db.collection('home_addresses').doc(uid).get();

var data= address.data();
if (data!=null) {
state= LoadedSuccessfulyAddressState(addressModal: AddressModal.fromMap(data??{}));  
}else{
  state= LoadedSuccessfulyAddressState(addressModal: null); 
}

}on FirebaseException catch (e) {
  state= ErrorAddressState(error: e.code);
}

}

Future<void> removeAddress(BuildContext context)async{
  var auth= FirebaseAuth.instance.currentUser;
var db= FirebaseFirestore.instance.collection('users').doc(auth!.uid);
try {
  state= LoadingAddressState();
  loadingDialog(context, 'Removing address...');
  await db.collection('home_addresses').doc(auth.uid).delete();
  await getAddress();
  state= InitialAddressState();
  SnackBarHelper.show('Address deleted successfuly');
  Navigator.pop(context);
} on FirebaseException catch (e) {
  state= ErrorAddressState(error: e.toString());
  GoRouter.of(context).pop();
  SnackBarHelper.show(e.code, color: Colors.red);
}

}

  Future<void> saveAddress(AddressModal addressModal, BuildContext context )async{
    var auth= FirebaseAuth.instance.currentUser;
var db= FirebaseFirestore.instance.collection('users').doc(auth!.uid);
state= LoadingAddressState();
loadingDialog(context, '', color: Colors.transparent);
try {
  state= LoadingAddressState();

  await db.collection('home_addresses').doc(auth.uid).set(addressModal.toMap(auth.uid));

state= InitialAddressState();
await getAddress();
SnackBarHelper.show('Address added successfuly', color: Colors.green);
Navigator.pop(context);
}on FirebaseException catch (e) {
  
  state= InitialAddressState();
SnackBarHelper.show(e.code, color: Colors.red);

}


  }
  
}


sealed class AddressState {
  const AddressState();
}
class InitialAddressState extends AddressState {
  const InitialAddressState();
}

class LoadingAddressState extends AddressState {
  const LoadingAddressState();
}

class LoadedSuccessfulyAddressState extends AddressState {
  final AddressModal? addressModal;
  const LoadedSuccessfulyAddressState({required this.addressModal});
}

class ErrorAddressState extends AddressState {
  final String error;
  const ErrorAddressState({required this.error});
}