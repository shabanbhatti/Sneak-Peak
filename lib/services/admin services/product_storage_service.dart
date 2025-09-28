import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class ProductStorageService {
  
final FirebaseStorage firebaseStorage;

ProductStorageService({required this.firebaseStorage});


Future<({List<String> imgLinks, List<String> imgPaths})> addProductFileToStorage(List<File> imgFileList, String refPath) async {
    var storage = firebaseStorage.ref(refPath);
    
      List<String> imgUrls = [];
      List<String> storageImgPaths = [];
      for (var index in imgFileList) {
        var child = storage.child(
          DateTime.now().microsecondsSinceEpoch.toString(),
        );
        await child.putFile(index);

        var link = await child.getDownloadURL();
        imgUrls.add(link);
        storageImgPaths.add(child.fullPath);
      }
      return (imgLinks: imgUrls, imgPaths: storageImgPaths);
  }

Future<List<({String imgLinks, String imgPaths})>> addProductFileToStorageForBanners(List<File> imgFileList, String refPath) async {
    var storage = firebaseStorage.ref(refPath);
    List<({String imgLinks, String imgPaths})> dataList=[];
     
      for (var index in imgFileList) {
        var child = storage.child(
          DateTime.now().microsecondsSinceEpoch.toString(),
        );
        await child.putFile(index);

        var link = await child.getDownloadURL();
       
        dataList.add((imgLinks: link, imgPaths: child.fullPath));
      }
      return dataList;
  }


Future<({List<String> imgLinks, List<String> imgPaths})> updateProductImages(List<File> imgFileList, List<String> imgLinks, List<String> imgPaths) async {
    var storage = firebaseStorage.ref('product_imgs');
    
      List<String> imgUrls = [...imgLinks];
      List<String> storageImgPaths = [...imgPaths];
      for (var index in imgFileList) {
        var child = storage.child(
          DateTime.now().microsecondsSinceEpoch.toString(),
        );
        await child.putFile(index);

        var link = await child.getDownloadURL();
        imgUrls.add(link);
        storageImgPaths.add(child.fullPath);
      }
      return (imgLinks: imgUrls, imgPaths: storageImgPaths);
  }


Future<void> deleteImages(int index,List<String> imgPaths,)async{

 await Future.wait(
        imgPaths.map((e) async {
          if (e == imgPaths[index]) {
            await firebaseStorage.ref(imgPaths[index]).delete();
          } 
        }),
      );
}


Future<void> deleteProduct(List<String> storageImgPath)async{

await Future.wait(storageImgPath.map((e) async{
  await firebaseStorage.ref(e).delete();
},));

}
Future<void> deleteBanner(String path)async{
  await firebaseStorage.ref(path).delete();
}

}