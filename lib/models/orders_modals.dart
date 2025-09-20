import 'package:sneak_peak/models/cart_poduct_modal.dart';

class OrdersModals {
  
  final String? userUid;
  
  final String? paymentStatus;
  final String? id;
  
  final String? deliveryStatus;
final String? timeDate;

final List<CartProductModal>? productsList;

  OrdersModals({
    this.productsList,
    this.userUid,
    this.id,
    this.timeDate,
    
    this.paymentStatus,
    
    
    
     this.deliveryStatus,
  });

  
  Map<String, dynamic> toMap(String uid,String myId ) {
    return {
      
      'userUid': uid,
      'products': productsList!.map((e) => e.toMapFromPendingPayment(e.id??'', e.img??[], e.storageImgsPath??[]),).toList(),
      'id': myId,
      'paymentStatus': paymentStatus,
      
      
      'deliveryStatus': deliveryStatus,
      'date_time':timeDate
    };
  }

  
  factory OrdersModals.fromMap(Map<String, dynamic> map) {
    return OrdersModals(
      
      userUid: map['userUid'] as String?,
     id: map['id'],
     productsList: (map['products'] as List<dynamic>).map((e) => CartProductModal.fromMap(e),).toList(),
      paymentStatus: map['paymentStatus'] as String?,
     timeDate: map['date_time'],
      deliveryStatus: map['deliveryStatus'] ?? '',
    );
  }


 OrdersModals copyWith({
    String? userUid,
    String? paymentStatus,
    String? id,
    String? deliveryStatus,
    String? timeDate,
    List<CartProductModal>? productsList,
  }) {
    return OrdersModals(
      userUid: userUid ?? this.userUid,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      id: id ?? this.id,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      timeDate: timeDate ?? this.timeDate,
      productsList: productsList ?? this.productsList,
    );
  }



}

