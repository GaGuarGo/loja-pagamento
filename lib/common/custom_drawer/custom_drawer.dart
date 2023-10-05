import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer_header.dart';
import 'package:loja_virtual/common/custom_drawer/drawer_tile.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 203, 236, 241),
                    Colors.white,
                  ]),
            ),
          ),
          ListView(
            children: [
              const CustomDrawerHeader(),
              const DrawerTile(iconData: Icons.home, title: "Início", page: 0),
              const DrawerTile(
                  iconData: Icons.list, title: "Produtos", page: 1),
              const DrawerTile(
                  iconData: Icons.playlist_add_check,
                  title: "Meus Pedidos",
                  page: 2),
              const DrawerTile(
                  iconData: Icons.location_on, title: "Lojas", page: 3),
              Consumer<UserManager>(builder: (_, userManager, __) {
                if (userManager.adminEnabled) {
                  return const Column(
                    children: [
                      Divider(),
                      DrawerTile(
                          iconData: Icons.settings, title: "Usuários", page: 4),
                      DrawerTile(
                          iconData: Icons.settings, title: "Pedidos", page: 5),
                    ],
                  );
                } else {
                  return Container();
                }
              }),
            ],
          ),
        ],
      ),
    );
  }
}
