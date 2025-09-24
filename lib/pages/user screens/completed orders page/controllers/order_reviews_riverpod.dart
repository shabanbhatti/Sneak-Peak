import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/orders_modals.dart';
import 'package:sneak_peak/provider/provider_objects.dart';
import 'package:sneak_peak/repository/user%20repository/user_cloud_db_repository.dart';

final reviewsProvider = StateNotifierProvider.family<
  ReviewStateNotifier,
  String,
  String
>((ref, id) {
  return ReviewStateNotifier(userRepo: ref.read(userCloudDbRepositoryProvider));
});

class ReviewStateNotifier extends StateNotifier<String> {
  final UserCloudDbRepository userRepo;
  ReviewStateNotifier({required this.userRepo}) : super('');

  Future<bool> addReview(
    double ratingByUser,
    String productId,
    OrdersModals orderModel,
  ) async {
 

    try {
      state = 'loading';
      await userRepo.addReviews(ratingByUser, productId, orderModel);
      state = 'done';
      return true;
    
    } catch (e) {
      state = e.toString();
      return false;
      
    }
  }
}
