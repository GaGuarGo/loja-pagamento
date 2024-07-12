import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loja_virtual/common/custom_icon_button.dart';
import 'package:loja_virtual/models/store.dart';

class StoreCard extends StatelessWidget {
  final Store store;
  const StoreCard({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            child: Image.network(store.image!),
          ),
          Container(
            height: 140,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        store.name!,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        store.addressText,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      Text(
                        store.openingText,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CustomIconButton(
                      iconData: Icons.map,
                      color: primaryColor,
                      onTap: () {},
                    ),
                    CustomIconButton(
                      iconData: Icons.phone,
                      color: primaryColor,
                      onTap: () {},
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
