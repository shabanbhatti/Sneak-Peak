import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/orders_modals.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';

final reviewsProvider = StateNotifierProvider.family.autoDispose<ReviewStateNotifier, String, String>((ref, id) {
  return ReviewStateNotifier();
});

class ReviewStateNotifier extends StateNotifier<String> {
  ReviewStateNotifier(): super('');
  

Future<void> addReview( BuildContext context, double ratingByUser, String productId , String userId, OrdersModals orderModel)async{

var db= FirebaseFirestore.instance.collection('products');
var userDb= FirebaseFirestore.instance.collection('users');
loadingDialog(context, '', color: Colors.transparent);

try {
  
var get=await db.doc(productId).get();

var data= get.data()??{};


 double totalRatingSum = data['totalRatingSum'] ?? 0.0;
    int totalUsersRated = (data['totalUsersRated'] ?? 0).toInt();


    
    Map<String, dynamic> reviews = data['reviews']??{};
      bool userHasRated = reviews.containsKey(userId);
    double oldUserRating = userHasRated ? reviews[userId] : 0.0;

    if (userHasRated) {
      
      totalRatingSum = totalRatingSum - oldUserRating + ratingByUser;
      reviews[userId] = ratingByUser;
    } else {
      
      totalRatingSum += ratingByUser;
      totalUsersRated += 1;
      reviews[userId] = ratingByUser;
    }


    double averageRating =(totalUsersRated>0)? totalRatingSum / totalUsersRated:0.0;
    

    await db.doc(productId).update({
      'totalRatingSum': totalRatingSum,
      'totalUsersRated': totalUsersRated,
      'averageRating': averageRating,
      'reviews': reviews,
    });

var getUser= await userDb.doc(userId).collection('to_ship').doc(orderModel.id).get();
var userData= getUser.data()??{};
List<Map<String, dynamic>> list= List.from(userData['products']??[]);
log('$list');
List<Map<String, dynamic>> newList=[];
for (var element in list) {
  if (element['id']==productId) {
    log('true');
    newList.add({
      ...element,
      'totalRatingSum': totalRatingSum,
      'totalUsersRated': totalUsersRated,
      'averageRating': averageRating,
      'reviews': reviews,});
  }else{

    newList.add(element);
  }
}
log('$newList');
await  userDb.doc(userId).collection('to_ship').doc(orderModel.id).update({
'products':newList
});
Navigator.pop(context);


      // var data = get.data() ?? {};

      // double totalRatingSum = data['totalRatingSum'] ?? 0.0;
      // int totalUsersRated = data['totalUsersRated'] ?? 0;
      // Map<String, dynamic> reviews = data['reviews'] ?? {};

      // // Check if user has already rated
      // bool userHasRated = reviews.containsKey(userId);
      // double oldUserRating = userHasRated ? reviews[userId] : 0.0;

      // if (userHasRated) {
      //   // Update existing rating
      //   totalRatingSum = totalRatingSum - oldUserRating + ratingByUser;
      //   reviews[userId] = ratingByUser;
      // } else {
      //   // Add new rating
      //   totalRatingSum += ratingByUser;
      //   totalUsersRated += 1;
      //   reviews[userId] = ratingByUser;
      // }

      // double averageRating = totalUsersRated > 0 ? totalRatingSum / totalUsersRated : 0.0;

      // await db.doc(productId).update({
      //   'totalRatingSum': totalRatingSum,
      //   'totalUsersRated': totalUsersRated,
      //   'averageRating': averageRating,
      //   'reviews': reviews,
      // });

      // Navigator.pop(context);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(userHasRated ? 'Review updated!' : 'Review added!'),
      //     backgroundColor: Colors.green,
      //   ),
      // );
}on FirebaseException catch (e) {
  Navigator.pop(context);
  SnackBarHelper.show(e.code ,color: Colors.red);
}


}


}