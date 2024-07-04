import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/models/page_manager.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/screens/admin_users/admin_users_screen.dart';
import 'package:loja_virtual/screens/home/home_screen.dart';
import 'package:loja_virtual/screens/products/products_screen.dart';
import 'package:provider/provider.dart';

// ignore: use_key_in_widget_constructors
class BaseScreen extends StatefulWidget {
  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (BuildContext context) => PageManager(_pageController),
      child: Consumer<UserManager>(builder: (_, userManager, __) {
        return PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            const HomeScreen(),
            const ProductsScreen(),
            Scaffold(
              drawer: const CustomDrawer(),
              appBar: AppBar(title: const Text("Meus Pedidos")),
            ),
            Scaffold(
              drawer: const CustomDrawer(),
              appBar: AppBar(title: const Text("Lojas")),
            ),
            if (userManager.adminEnabled) ...[
              const AdminUsersScreen(),
              Scaffold(
                drawer: const CustomDrawer(),
                appBar: AppBar(title: const Text("Pedidos")),
              )
            ]
          ],
        );
      }),
    );
  }
}
