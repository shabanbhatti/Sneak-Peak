import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sneak_peak/models/products_modals.dart';

class ProductService {


Future<void> addProduct(ProductModal productModal)async{

var db= FirebaseFirestore.instance.collection('products');

var id= DateTime.now().microsecondsSinceEpoch.toString();
await db.doc(id).set(productModal.toMap(id));


}

Future<void> updateProduct(ProductModal productModal)async{

var db = FirebaseFirestore.instance.collection('products');

await db.doc(productModal.id).update(productModal.toMapForUpdate(productModal.id!));

}


Future<void> deleteProduct(String productId, List<String> storageImgPath)async{
var db = FirebaseFirestore.instance.collection('products');
var storage= FirebaseStorage.instance;


for (var element in storageImgPath) {
  storage.ref(element).delete();
}

await db.doc(productId).delete();

}

Future<void> deleteAll()async{
var db = FirebaseFirestore.instance.collection('products');
var storage= FirebaseStorage.instance;
var data= await db.get();


await Future.wait(data.docs.map((e)async{
List<String> imgPaths= List.from(e['storage_imgs_paths']??[]);

 for (final path in imgPaths) {
          try {
            await storage.ref(path).delete();
            print('Deleted image: $path');
          } catch (e) {
            print('Error$path: $e');
          }
        }
  await db.doc(e.id).delete();
}));
}


}
