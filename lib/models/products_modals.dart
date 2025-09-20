import 'dart:core';

class ProductModal {
  final String? title;
  final String? description;
  final String? price;
  final String? id;
  final String? brand;
  final List<String>? colors;
  final List<String>? img;
  final List<String>? genders;
  final List<String>? storageImgsPath;
final List<int>? shoesSizes;
final int? totalRatedUser;
final double? reviews;
  final bool? isProductExist;
  final int? solds;
  final int? quantity;

  const ProductModal({
     this.title,
     this.shoesSizes,
     this.quantity,
     this.totalRatedUser=0,
     this.solds,
     this.reviews=0.0,
     
     this.description,
     this.isProductExist=true,
    this.id,
     this.brand,
     this.price,
     this.colors,
     this.genders,
    this.img,
     this.storageImgsPath,
     
  });

  factory ProductModal.fromMap(Map<String, dynamic> map,) {
    return ProductModal(
      brand: map['brand']??'',
      title: map['title']??'',
      solds: map['solds']??0,
      quantity: map['quantity']??1,
      reviews: map['averageRating']??0.0,
      totalRatedUser: map['totalUsersRated']??0,
      description: map['description']??'',
      price: map['price']??'',
     shoesSizes: List.from(map['shoes_sizes']??[]),
      colors: List.from(map['colors']??[]),
      img: List.from(map['images']??[]),
      genders: List.from(map['genders']??[]),
      storageImgsPath: List.from(map['storage_imgs_paths']??[]),
      id: map['id'],
    );
  }




  Map<String, dynamic> toMap(String productId) {
    return {
      'title': title,
      'description': description,
      'price': price,
      'images': img,
      'colors': colors,
      'brand':brand,
      'genders':genders,
      'id': productId,
      'storage_imgs_paths': storageImgsPath,
     'shoes_sizes':shoesSizes,
     'averageRating': reviews,
     'solds': solds

    };
  }

  Map<String, dynamic> toMapForUser(String productId,List<String> imgLink ,List<String> paths) {
    return {
      'title': title,
      'description': description,
      'price': price,
      'images': imgLink,
      'colors': colors,
      'brand':brand,
      'genders':genders,
      'id': productId,
      'storage_imgs_paths': paths,
     'shoes_sizes': shoesSizes,
      'averageRating': reviews,
     'solds': solds
    };
  }


  Map<String, dynamic> toMapForUpdate(String productId) {
    return {
      'title': title,
      'description': description,
      'price': price,
      'brand': brand,
      'colors': colors,
      'genders':genders,
      'id': productId,
      'shoes_sizes': shoesSizes
    };
  }

   
}
