import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/common/empty_card.dart';
import 'package:loja_virtual/models/admin_orders_manager.dart';
import 'package:loja_virtual/screens/orders/components/order_tile.dart';
import 'package:provider/provider.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
        centerTitle: true,
      ),
      body: Consumer<AdminOrdersManager>(
        builder: (_, ordersManager, __) {
          if (ordersManager.orders.isEmpty) {
            return EmptyCard(
                title: 'Nenhuma Venda Realizada!',
                iconData: Icons.border_clear);
          }

          return ListView.builder(
            itemCount: ordersManager.orders.length,
            itemBuilder: (context, index) {
              return OrderTile(
                order: ordersManager.orders.reversed.toList()[index],
                showControls: true,
              );
            },
          );
        },
      ),
    );
  }
}
