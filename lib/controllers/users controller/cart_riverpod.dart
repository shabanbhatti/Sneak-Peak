import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/cart_poduct_modal.dart';
import 'package:sneak_peak/models/products_modals.dart';
import 'package:sneak_peak/provider/provider_objects.dart';
import 'package:sneak_peak/repository/user%20repository/user_cloud_db_repository.dart';


final cartProvider =
    StateNotifierProvider<CartNotifier, String>((ref) {
      return CartNotifier(userRepository: ref.read(userCloudDbRepositoryProvider));
    });

class CartNotifier extends StateNotifier<String> {
  final UserCloudDbRepository userRepository;
  CartNotifier({required this.userRepository}) : super('init');

  Future<bool> addToCartBtnClick(ProductModal productModal) async {
    // var auth = FirebaseAuth.instance.currentUser;
    // var db = FirebaseFirestore.instance.collection('users').doc(auth!.uid);
    
    state = 'loading';
    // loadingDialog(context, 'Adding to cart...');
    try {
      var cartModal = CartProductModal(
        id: productModal.id,
        brand: productModal.brand,
        colors: productModal.colors,
        description: productModal.description,
        genders: productModal.genders,
        price: productModal.price,
        img: productModal.img,
        quantity: 1,
        storageImgsPath: productModal.storageImgsPath,
        title: productModal.title,
        shoesSizes: productModal.shoesSizes,
        reviews: productModal.reviews,
        totalRatedUser: productModal.totalRatedUser
      );
await userRepository.addToCartBtn(cartModal);

      // await db
      //     .collection('carts')
      //     .doc(cartModal.id)
      //     .set(
      //       cartModal.toMap(
      //         cartModal.id!,
      //         cartModal.img ?? [],
      //         [],
      //         cartModal.quantity!,
      //         int.parse(cartModal.price.toString()),
      //       ),
      //     );
      state = 'done';
      return true;
      // SnackBarHelper.show('Add to cart successfuly');
      // Navigator.pop(context);
      // Navigator.pop(context);
    } catch (e) {
      state=e.toString();
      return false;
      // Navigator.pop(context);
      // SnackBarHelper.show('$e');
    }
  }


  Future<void> updateForExistance(String id, bool isExist)async{
// var auth= FirebaseAuth.instance.currentUser;
// var db= FirebaseFirestore.instance.collection('users').doc(auth!.uid);

try {
state= 'loading';  
  await userRepository.updateForExistance(isExist, id);
// await db.collection('carts').doc(id).update({
//   'isProductAvailaibe': isExist
// });
state= 'done';

} catch (e) {
  // SnackBarHelper.show(e.code, color: Colors.red);
  state= e.toString();
}


  }

Future<bool> deleteCart(String id )async{
// var auth = FirebaseAuth.instance.currentUser;
// var db= FirebaseFirestore.instance.collection('users').doc(auth!.uid);
// loadingDialog(context, 'Deleting...');
try {
  state= 'loading';
// await db.collection('carts').doc(id).delete();
await userRepository.deleteCart(id);
// Navigator.pop(context);
state= 'done';
return true;
} catch (e) {
  state=e.toString();
  return false;
  // Navigator.pop(context);
  // SnackBarHelper.show(e.code, color: Colors.red);
}

}


}
