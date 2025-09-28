import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/orders_modals.dart';
import 'package:sneak_peak/provider/provider_objects.dart';
import 'package:sneak_peak/repository/admin%20repository/product_cloud_db_repository.dart';


final updateStepsProvider = StateNotifierProvider<UpdateStepsNotifier, String>((ref) {
  return UpdateStepsNotifier(productCloudDbRepository: ref.read(productServiceRepositoryProviderObject));
});

class UpdateStepsNotifier extends StateNotifier<String> {
  ProductCloudDbRepository productCloudDbRepository;
  UpdateStepsNotifier({required this.productCloudDbRepository}): super('');
  
Future<bool> updateStep(OrdersModals orderModel,String step ,String uid)async{

try {

  await productCloudDbRepository.updateSteps(orderModel, step, uid);
  
  state='done';
  return true;
} catch (e) {
  state= e.toString();
  return false;
}


}

}