import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/models/admin_orders_manager.dart';
import 'package:loja_virtual/models/admin_users_manager.dart';
import 'package:loja_virtual/models/page_manager.dart';
import 'package:provider/provider.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const CustomDrawer(),
        appBar: AppBar(
          title: const Text('Usuários'),
          centerTitle: true,
        ),
        body: Consumer<AdminUsersManager>(
          builder: (_, adminUM, __) {
            return AlphabetListScrollView(
              highlightTextStyle:
                  const TextStyle(color: Colors.white, fontSize: 20),
              showPreview: true,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    adminUM.users[index].name!,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                  subtitle: Text(
                    adminUM.users[index].email!,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    context
                        .read<AdminOrdersManager>()
                        .setUserFilter(adminUM.users[index]);

                    context.read<PageManager>().setPage(5);
                  },
                );
              },
              // ignore: avoid_types_as_parameter_names
              indexedHeight: (int) => 80,
              strList: adminUM.names,
            );
          },
        ));
  }
}
