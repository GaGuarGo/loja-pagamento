import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_order.dart';

class OrderTile extends StatelessWidget {
  final UserOrder order;
  const OrderTile({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              'Em transporte',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: primaryColor,
                  fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
