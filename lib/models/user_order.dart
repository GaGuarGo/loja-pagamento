import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/cart_product.dart';

class UserOrder {
  UserOrder.fromCartManager(CartManager cartManager) {
    items = List.from(cartManager.items);
    price = cartManager.totalPrice;
    userId = cartManager.user!.id;
    address = cartManager.address;
  }

  String? orderId;
  List<CartProduct>? items;
  num? price;
  String? userId;
  Address? address;
  Timestamp? date;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> save() async {
    firestore.collection('orders').doc(orderId).set(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items!.map((i) => i.toOrderItemMap()).toList(),
      'price': price,
      'user': userId,
      'address': address!.toMap(),
    };
  }
}
