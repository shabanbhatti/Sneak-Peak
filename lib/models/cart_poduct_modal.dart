import 'dart:core';

class CartProductModal {
  final String? title;
  final String? description;
  final String? price;
  final String? id;
  final String? brand;
  final List<String>? colors;
  final List<String>? img;
  final List<String>? genders;
  final List<int>? shoesSizes;
  final List<String>? storageImgsPath;
  final int? quantity;
  final int? originalPrice;
  final bool? isProductExist;
final int? totalRatedUser;
final double? reviews;
final int? solds;
  

  const CartProductModal({
     this.title,
     this.quantity,
     this.reviews=0.0,
     this.solds=0,
     this.totalRatedUser=0,
     this.isProductExist=true,
     this.description,
     this.shoesSizes,
    this.id,
     this.brand,
     this.price,
     this.colors,
     this.genders,
    this.img,
     this.storageImgsPath,
     this.originalPrice
  });

  factory CartProductModal.fromMap(Map<String, dynamic> map,) {
    return CartProductModal(
      brand: map['brand']??'',
      title: map['title']??'',
      solds: map['solds']??0,
      description: map['description']??'',
      isProductExist: map['isProductAvailaibe']??true,
       reviews: map['averageRating']??0.0,
      totalRatedUser: map['totalUsersRated']??0,
      price: map['price']??'',
      shoesSizes: List.from(map['shoes_sizes']??[]),
     quantity: map['quantity']??1,
      colors: List.from(map['colors']??[]),
      img: List.from(map['images']??[]),
      genders: List.from(map['genders']??[]),
      storageImgsPath: List.from(map['storage_imgs_paths']??[]),
      id: map['id'],
      originalPrice: map['original_price']
    );
  }


 
  Map<String, dynamic> toMap(String productId,List<String> imgLink ,List<String> paths, int productQuantity, int originalPrice) {
    return {
      'title': title,
      'description': description,
      'price': price,
      'images': imgLink,
      'colors': colors,
      'brand':brand,
      'genders':genders,
      'isProductAvailaibe':isProductExist,
      'id': productId,
      'storage_imgs_paths': paths,
     'quantity': productQuantity,
     'original_price': originalPrice,
     'shoes_sizes':shoesSizes,
     'averageRating': reviews,
     'totalUsersRated': totalRatedUser
    };
  }


   Map<String, dynamic> toMapFromPendingPayment(String productId,List<String> imgLink ,List<String> paths,) {
    return {
      'title': title,
      'description': description,
      'price': price,
      'images': imgLink,
      'colors': colors,
      'brand':brand,
      'isProductAvailaibe':isProductExist,
      'genders':genders,
      'id': productId,
      'storage_imgs_paths': paths,
     'quantity': quantity,
     'original_price': originalPrice,
     'shoes_sizes':shoesSizes,
      'averageRating': reviews,
     'totalUsersRated': totalRatedUser
    };
  }



 CartProductModal copyWith({
    String? title,
    String? description,
    String? price,
    String? id,
    String? brand,
    List<String>? colors,
    List<String>? img,
    List<String>? genders,
    List<int>? shoesSizes,
    List<String>? storageImgsPath,
    int? quantity,
    int? originalPrice,
    bool? isProductExist,
  }) {
    return CartProductModal(
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      id: id ?? this.id,
      brand: brand ?? this.brand,
      colors: colors ?? this.colors,
      img: img ?? this.img,
      genders: genders ?? this.genders,
      shoesSizes: shoesSizes ?? this.shoesSizes,
      storageImgsPath: storageImgsPath ?? this.storageImgsPath,
      quantity: quantity ?? this.quantity,
      originalPrice: originalPrice ?? this.originalPrice,
      isProductExist: isProductExist ?? this.isProductExist,
    );
  }



   
}
