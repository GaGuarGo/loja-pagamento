import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/section.dart';

class HomeManager {
  HomeManager() {
    _loadSections();
  }

  List<Section> sections = [];

  final _firestore = FirebaseFirestore.instance;

  Future<void> _loadSections() async {
    _firestore.collection('home').snapshots().listen((snapshot) {
      sections.clear();
      for (final DocumentSnapshot document in snapshot.docs) {
        sections.add(Section.fromDocument(document));
      }
      print(sections);
    });
  }
}
