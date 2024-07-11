import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:loja_virtual/models/item_size.dart';
import 'package:uuid/uuid.dart';

class Product extends ChangeNotifier {
  Product(
      {this.id,
      this.name,
      this.description,
      this.images,
      this.sizes,
      this.deleted = false}) {
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
    deleted = (document['deleted'] ?? false) as bool;
  }

  final _fireStore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  DocumentReference get firestoreRef => _fireStore.doc('products/$id');
  Reference get storageRef => _storage.ref().child('products').child(id!);

  String? id;
  String? name;
  String? description;
  List<String>? images;
  List<ItemSize>? sizes;

  List<dynamic>? newImages;

  bool? deleted;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

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
    loading = true;

    final data = <String, dynamic>{
      "name": name,
      "description": description,
      "sizes": exportSizeList(),
      "deleted": deleted,
    };

    if (id == null) {
      final doc = await _fireStore.collection('products').add(data);
      id = doc.id;
    } else {
      await firestoreRef.update(data);
    }

    final List<String> updatedImages = [];
    // Generate a v1 (time-based) id
    var uuid = const Uuid();
    var v1 = uuid.v1();

    for (final newImage in newImages!) {
      if (images!.contains(newImage)) {
        updatedImages.add(newImage as String);
      } else {
        final task = await storageRef.child(v1).putFile(newImage as File);
        final url = await task.ref.getDownloadURL();
        updatedImages.add(url);
      }
    }

    for (final image in images!) {
      if (!newImages!.contains(image) && image.contains('firebase')) {
        try {
          final ref = _storage.refFromURL(image);
          await ref.delete();
        } catch (e) {
          debugPrint('Falha ao deletar url: $image');
        }
      }
    }

    await firestoreRef.update({'images': updatedImages});

    images = updatedImages;

    loading = false;
  }

  void delete() {
    firestoreRef.update({'deleted': true});
  }

  Product clone() {
    return Product(
      id: id,
      name: name,
      description: description,
      images: List.from(images!),
      sizes: sizes!.map((size) => size.clone()).toList(),
      deleted: deleted,
    );
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, description: $description, images: $images, newImages: $newImages}';
  }
}
