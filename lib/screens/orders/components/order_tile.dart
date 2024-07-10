import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_order.dart';
import 'package:loja_virtual/screens/orders/components/order_product_tile.dart';

class OrderTile extends StatelessWidget {
  final UserOrder order;
  final bool showControls;
  const OrderTile({super.key, required this.order, this.showControls = false});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.formattedId,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
                Text(
                  'R\$ ${order.price!.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 14),
                ),
              ],
            ),
            Text(
              order.statusText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color:
                    order.status == Status.canceled ? Colors.red : primaryColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
        children: [
          Column(
            children: order.items!
                .map((e) => OrderProductTile(cartProduct: e))
                .toList(),
          ),
          if (showControls && order.status != Status.canceled) ...[
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: order.cancel,
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        )),
                    TextButton(
                        onPressed: order.back,
                        child: Text(
                          'Recuar',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        )),
                    TextButton(
                        onPressed: order.advance,
                        child: Text(
                          'Avançar',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        )),
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          'Endereço',
                          style: TextStyle(
                              color: primaryColor, fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      'Remover Pedido',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }
}
