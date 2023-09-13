import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/item_size.dart';

class Product {
  Product.fromDocument(DocumentSnapshot document) {
    id = document.id;
    name = document['name'] as String;
    description = document['description'] as String;
    images = List<String>.from(document['images'] as List<dynamic>);
    sizes = (document.get('sizes') as List<dynamic>)
        .map((s) => ItemSize.fromMap(s))
        .toList();
  }

  String? id;
  String? name;
  String? description;
  List<String>? images;
  List<ItemSize>? sizes;
}
