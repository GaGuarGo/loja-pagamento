import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:loja_virtual/models/item_size.dart';
import 'package:loja_virtual/models/product.dart';

class CartProduct extends ChangeNotifier {
  CartProduct.fromProduct(this.product) {
    productId = product!.id;
    quantity = 1;
    size = product!.selectedSize.name;
  }

  CartProduct.fromDocument(DocumentSnapshot document) {
    id = document.id;
    productId = document.get('pid') as String;
    quantity = document.get('quantity') as int;
    size = document.get('size') as String;

    firestrore.doc('products/$productId').get().then((doc) {
      product = Product.fromDocument(doc);
      notifyListeners();
    });
  }

  CartProduct.fromMap(Map<String, dynamic> map) {
    productId = map['pid'] as String;
    quantity = map['quantity'] as int;
    size = map['size'] as String;
    fixedPrice = map['fixedPrice'] as num;

    firestrore.doc('products/$productId').get().then((doc) {
      product = Product.fromDocument(doc);
      notifyListeners();
    });
  }

  final firestrore = FirebaseFirestore.instance;

  String? id;

  String? productId;
  int? quantity;
  String? size;

  num? fixedPrice;

  Product? product;
  void setProduct(Product p) {
    product = p;
    notifyListeners();
  }

  ItemSize? get itemSize {
    if (product == null) return null;
    return product!.findSize(size!);
  }

  num get unitPrice {
    if (product == null) {
      return 0;
    } else {
      return itemSize!.price ?? 0;
    }
  }

  num get totalPrice => unitPrice * quantity!;

  Map<String, dynamic> toCartItemMap() {
    return {
      'pid': productId,
      'quantity': quantity,
      'size': size,
    };
  }

  Map<String, dynamic> toOrderItemMap() {
    return {
      'pid': productId,
      'quantity': quantity,
      'size': size,
      'fixedPrice': fixedPrice ?? unitPrice,
    };
  }

  bool stackable(Product product) {
    return product.id == productId && product.selectedSize.name == size;
  }

  void increment() {
    quantity = quantity! + 1;
    notifyListeners();
  }

  void decrement() {
    quantity = quantity! - 1;
    notifyListeners();
  }

  bool get hasStock {

    if(product != null && product!.deleted!) return false;

    final size = itemSize;
    if (size == null) return false;

    return size.stock! >= quantity!;
  }
}
