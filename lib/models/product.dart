import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:loja_virtual/models/item_size.dart';

class Product extends ChangeNotifier {
  Product({this.id, this.name, this.description, this.images, this.sizes}) {
    images = images ?? [];
    sizes = sizes ?? [];
  }

  Product.fromDocument(DocumentSnapshot document) {
    id = document.id;
    name = document['name'] as String;
    description = document['description'] as String;
    images = List<String>.from(document['images'] as List<dynamic>);
    sizes = (document.get('sizes') as List<dynamic>)
        .map((s) => ItemSize.fromMap(s))
        .toList();
  }

  final _fireStore = FirebaseFirestore.instance;

  DocumentReference get firestoreRef => _fireStore.doc('products/$id');

  String? id;
  String? name;
  String? description;
  List<String>? images;
  List<ItemSize>? sizes;

  List<dynamic>? newImages;

  ItemSize _selectedSize =
      ItemSize.fromMap({'name': '', 'price': 0, 'stock': 0});
  ItemSize get selectedSize => _selectedSize;
  set selectedSize(ItemSize value) {
    _selectedSize = value;
    notifyListeners();
  }

  int get totalStock {
    int stock = 0;
    for (final size in sizes!) {
      stock += size.stock!;
    }
    return stock;
  }

  bool get hasStock => totalStock > 0;

  num get basePrice {
    num lowest = double.infinity;
    for (final size in sizes!) {
      if (size.price! < lowest && size.hasStock) {
        lowest = size.price!;
      }
    }
    return lowest;
  }

  ItemSize? findSize(String name) {
    try {
      return sizes!.firstWhere((s) => s.name == name);
    } catch (e) {
      return null;
    }
  }

  List<Map<String, dynamic>> exportSizeList() {
    return sizes!.map((size) => size.toMap()).toList();
  }

  Future<void> save() async {
    final data = <String, dynamic>{
      "name": name,
      "description": description,
      "sizes": exportSizeList(),
    };

    if (id == null) {
      final doc = await _fireStore.collection('products').add(data);
      id = doc.id;
    } else {
      await firestoreRef.update(data);
    }
  }

  Product clone() {
    return Product(
      id: id,
      name: name,
      description: description,
      images: List.from(images!),
      sizes: sizes!.map((size) => size.clone()).toList(),
    );
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, description: $description, images: $images, newImages: $newImages}';
  }
}
