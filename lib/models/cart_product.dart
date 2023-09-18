import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/item_size.dart';
import 'package:loja_virtual/models/product.dart';

class CartProduct {
  CartProduct.fromProduct(this.product) {
    productId = product!.id;
    quantity = 1;
    size = product!.selectedSize.name;
  }

  CartProduct.fromDocument(DocumentSnapshot document) {
    productId = document.get('pid') as String;
    quantity = document.get('quantity') as int;
    size = document.get('size ') as String;

    firestrore.doc('products/$productId').get().then((doc) {
      product = Product.fromDocument(doc);
    });
  }

  final firestrore = FirebaseFirestore.instance;

  String? productId;
  int? quantity;
  String? size;

  Product? product;

  ItemSize? get itemSize {
    if (product == null) return null;
    return product?.findSize(size!);
  }

  num get unitPrice {
    if (product == null) {
      return 0;
    } else {
      return itemSize!.price ?? 0;
    }
  }
}
