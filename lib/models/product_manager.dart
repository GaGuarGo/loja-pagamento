import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/product.dart';

class ProductManager extends ChangeNotifier {
  ProductManager() {
    _loadAllProducts();
  }

  final _firestore = FirebaseFirestore.instance;

  // ignore: unused_field
  List<Product> allProducts = [];

  Future<void> _loadAllProducts() async {
    final snapProducts = await _firestore.collection('products').get();

    allProducts =
        snapProducts.docs.map((d) => Product.fromDocument(d)).toList();
    notifyListeners();
  }
}
