import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/section_item.dart';

class Section {
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
