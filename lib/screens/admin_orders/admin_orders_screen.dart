import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/common/custom_icon_button.dart';
import 'package:loja_virtual/common/empty_card.dart';
import 'package:loja_virtual/models/admin_orders_manager.dart';
import 'package:loja_virtual/models/user_order.dart';
import 'package:loja_virtual/screens/orders/components/order_tile.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AdminOrdersScreen extends StatefulWidget {
  AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  final panelController = PanelController();

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
          final filteredOrders = ordersManager.filteredOrders;

          return SlidingUpPanel(
            controller: panelController,
            minHeight: 40,
            maxHeight: 240,
            panel: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    if (panelController.isPanelClosed) {
                      panelController.open();
                    } else {
                      panelController.close();
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 40,
                    color: Colors.white,
                    child: Text(
                      'Filtros',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: Status.values
                        .map((s) => CheckboxListTile(
                              activeColor: Theme.of(context).primaryColor,
                              dense: true,
                              title: Text(
                                UserOrder.getStatusText(s),
                              ),
                              value: ordersManager.statusFilter.contains(s),
                              onChanged: (value) {
                                ordersManager.setStatusFilter(status: s);
                              },
                            ))
                        .toList(),
                  ),
                )
              ],
            ),
            body: Column(
              children: <Widget>[
                if (ordersManager.userFilter != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 2),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'Pedidos de ${ordersManager.userFilter!.name}',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        CustomIconButton(
                          iconData: Icons.close,
                          color: Colors.white,
                          onTap: () {
                            ordersManager.setUserFilter(null);
                          },
                        )
                      ],
                    ),
                  ),
                if (filteredOrders.isEmpty)
                  Expanded(
                    child: EmptyCard(
                      title: 'Nenhuma venda realizada!',
                      iconData: Icons.border_clear,
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                        itemCount: filteredOrders.length,
                        itemBuilder: (_, index) {
                          return OrderTile(
                            order: filteredOrders[index],
                            showControls: true,
                          );
                        }),
                  ),
                const SizedBox(
                  height: 120,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
