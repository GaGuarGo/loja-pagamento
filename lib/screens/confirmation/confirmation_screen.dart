import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_order.dart';
import 'package:loja_virtual/screens/orders/components/order_product_tile.dart';

class ConfirmationScreen extends StatelessWidget {
  final UserOrder order;
  const ConfirmationScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Pedido Confirmado - ${order.formattedId}'),
        centerTitle: true,
      ),
      body: Card(
        margin: const EdgeInsets.all(16),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    order.formattedId,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    'R\$ ${order.price!.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: order.items!.map((e) {
                return OrderProductTile(cartProduct: e);
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
