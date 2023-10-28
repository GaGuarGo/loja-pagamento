import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/section_item.dart';

class Section extends ChangeNotifier {
  Section({this.name, this.type, this.items}) {
    items = items ?? [];
  }

  Section.fromDocument(DocumentSnapshot document) {
    name = document.get('name') as String;
    type = document.get('type') as String;

    items = (document.get('items') as List)
        .map((i) => SectionItem.fromMap(i as Map<String, dynamic>))
        .toList();
  }

  String? name;
  String? type;
  List<SectionItem>? items;

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
