import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';

class AdminUsersManager extends ChangeNotifier {
  List<UserModel> users = [];

  void updateUser(UserManager userManager) {
    if (userManager.adminEnabled) {
      _listenToUsers();
    }
  }

  void _listenToUsers() {
    final faker = Faker();

    for (int i = 0; i < 1000; i++) {
      users.add(UserModel(
        name: faker.person.name(),
        email: faker.internet.email(),
      ));
    }

    users
        .sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
    notifyListeners();
  }

  List<String> get names => users.map((e) => e.name!).toList();
}
