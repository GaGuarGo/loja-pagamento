import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/section_item.dart';
import 'package:uuid/uuid.dart';

class Section extends ChangeNotifier {
  Section({this.id, this.name, this.type, this.items}) {
    items = items ?? [];
    originalItems = List.from(items!);
  }

  Section.fromDocument(DocumentSnapshot document) {
    id = document.id;
    name = document.get('name') as String;
    type = document.get('type') as String;

    items = (document.get('items') as List)
        .map((i) => SectionItem.fromMap(i as Map<String, dynamic>))
        .toList();
  }

  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  DocumentReference get firestoreRef => firestore.doc('home/$id');
  Reference get storageRef => storage.ref().child('home').child(id!);

  String? id;
  String? name;
  String? type;
  List<SectionItem>? items;
  List<SectionItem>? originalItems;

  String _error = "";
  String get error => _error;
  set error(String value) {
    _error = value;
    notifyListeners();
  }

  void addItem(SectionItem item) {
    items?.add(item);
    notifyListeners();
  }

  void removeItem(SectionItem item) {
    items?.remove(item);
    notifyListeners();
  }

  Future<void> save(int pos) async {
    final data = <String, dynamic>{"name": name, "type": type, "pos": pos};

    if (id == null) {
      final doc = await firestore.collection('home').add(data);
      id = doc.id;
    } else {
      await firestoreRef.update(data);
    }

    for (final item in items!) {
      if (item.image is File) {
        final task = storageRef.child(Uuid().v1()).putFile(item.image as File);
        await task.whenComplete(() async {
          final url = await task.snapshot.ref.getDownloadURL();
          item.image = url;
        });
      }
    }

    for (final original in originalItems!) {
      if (!items!.contains(original)) {
        try {
          final ref = await storage.refFromURL(original.image as String);
          await ref.delete();
        } catch (e) {}
      }
    }

    final itemsData = <String, dynamic>{
      'items': items?.map((e) => e.toMap()).toList(),
    };

    await firestoreRef.update(itemsData);
  }

  Future<void> delete() async {
    await firestoreRef.delete();
    for (final item in items!) {
      try {
        final ref = await storage.refFromURL(item.image as String);
        await ref.delete();
      } catch (e) {}
    }
  }

  bool valid() {
    if (name == null || name!.isEmpty) {
      error = "Título Inválido";
    } else if (items!.isEmpty) {
      error = "Insira Ao Menos Uma Imagem";
    } else {
      error = "";
    }
    return error.isEmpty;
  }

  Section clone() {
    return Section(
      id: id,
      name: name,
      type: type,
      items: items?.map((e) => e.clone()).toList(),
    );
  }

  @override
  String toString() {
    return 'SectionName: $name, type: $type, items: $items';
  }
}
