import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer/drawer_tile.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: const [
          DrawerTile(iconData: Icons.home, title: "Início", page: 0),
          DrawerTile(iconData: Icons.list, title: "Produtos", page: 1),
          DrawerTile(
              iconData: Icons.playlist_add_check,
              title: "Meus Pedidos",
              page: 2),
          DrawerTile(iconData: Icons.location_on, title: "Lojas", page: 3),
        ],
      ),
    );
  }
}
