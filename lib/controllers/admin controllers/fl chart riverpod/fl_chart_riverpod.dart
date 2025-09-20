import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/utils/constant_brands.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';

final flChartProvider = StateNotifierProvider<FlChartStateNotifier, ({int ndure, int bata, int servis, int stylo, bool isLoading,bool isError ,String error})>((ref) {
  return FlChartStateNotifier();
});

class FlChartStateNotifier extends StateNotifier<({int ndure, int bata, int servis, int stylo, bool isLoading,bool isError,String error})> {
  FlChartStateNotifier(): super((ndure:0, bata:0, servis: 0, stylo: 0, isLoading: false,isError: false ,error: ''));
  

Future<void> getData(BuildContext context )async{
var db= FirebaseFirestore.instance.collection('total_solds');
loadingDialog(context, '', color: Colors.transparent);
state= (ndure:0, bata:0, servis: 0, stylo: 0, isLoading: true,isError: false, error: '');
try {
var ndureGet=await db.doc(ndure).get();
var ndureData= ndureGet.data()??{};
var ndureValue= ndureData['total_solds']??0;

var bataGet=await db.doc(bata).get();
var bataData= bataGet.data()??{};
var bataValue= bataData['total_solds']??0;

var servisGet=await db.doc(servis).get();
var servisData= servisGet.data()??{};
var servisvalue= servisData['total_solds']??0;


var styloGet=await db.doc(stylo).get();
var styloData= styloGet.data()??{};
var styloValue= styloData['total_solds']??0;


state=(bata: bataValue, ndure: ndureValue, servis: servisvalue, stylo: styloValue,isLoading: false,isError: false , error: '');
Navigator.pop(context);

}on FirebaseException catch (e) {
  Navigator.pop(context);
  state= (ndure:0, bata:0, servis: 0, stylo: 0, isLoading: false,isError: true, error: e.code);
  SnackBarHelper.show(e.code, color: Colors.red);
}


}





Future<void> initialize()async{

var productsDb= FirebaseFirestore.instance.collection('products');
var totalSold= FirebaseFirestore.instance.collection('total_solds');
var get=await productsDb.get();
var data= get.docs;

int ndureSolds=0;
int styloSolds=0;
int bataSolds= 0;
int servisSolds=0;
try {


for (var element in data) {

var brand= element['brand'].toString();
if (brand==ndure) {
int solds= element['solds']??0;
ndureSolds+=solds;
await totalSold.doc(ndure).set({'total_solds': ndureSolds});

}else if (brand==stylo) {
int solds= element['solds']??0;
styloSolds+=solds;
await totalSold.doc(stylo).set({'total_solds': styloSolds});

}else if (brand==bata) {
int solds= element['solds']??0;
bataSolds+=solds;
await totalSold.doc(bata).set({'total_solds': bataSolds});

}else if(brand==servis){

int solds= element['solds']??0;
servisSolds+=solds;
await totalSold.doc(servis).set({'total_solds': servisSolds});

}else{
  
int solds= element['solds']??0;

await totalSold.doc('ANONYMOUS').set({'total_solds': solds});

}



}


}on FirebaseException catch (e) {
  SnackBarHelper.show(e.code, color: Colors.red);
}


}


}