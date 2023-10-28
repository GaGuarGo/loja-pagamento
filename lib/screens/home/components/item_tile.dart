import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/product_manager.dart';
import 'package:loja_virtual/models/section.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../models/section_item.dart';

class ItemTile extends StatelessWidget {
  final String type;
  final SectionItem item;

  const ItemTile({super.key, required this.item, required this.type});

  @override
  Widget build(BuildContext context) {
    final homeManagaer = context.watch<HomeManager>();

    // final product =
    //     context.read<ProductManager>().findProductById(item.product!);

    return GestureDetector(
      onLongPress: homeManagaer.editing
          ? () {
              showDialog(
                  context: context,
                  builder: (_) {
                    final product = context
                        .read<ProductManager>()
                        .findProductById(item.product);

                    return AlertDialog(
                      title: const Text("Editar Item"),
                      content: product != null
                          ? ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Image.network(product.images!.first),
                              title: Text(product.name!),
                              subtitle: Text(
                                  "R\$ ${product.basePrice.toStringAsFixed(2)}"),
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(),
                              ],
                            ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              context.read<Section>().removeItem(item);
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              "Excluir",
                              style: TextStyle(color: Colors.red),
                            )),
                        TextButton(
                            onPressed: () async {
                              if (product != null) {
                                item.product = null;
                              } else {
                                final Product product =
                                    await Navigator.of(context)
                                            .pushNamed("/select_product")
                                        as Product;
                                item.product = product.id;
                              }
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              product != null ? "Desvincular" : "Vincular",
                              style: TextStyle(color: Colors.blue),
                            ))
                      ],
                    );
                  });
            }
          : null,
      onTap: () {
        if (item.product != null) {
          final product =
              context.read<ProductManager>().findProductById(item.product!);

          if (product != null) {
            Navigator.of(context).pushNamed('/product', arguments: product);
          }
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: type == "List"
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: item.image is String
                          ? FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: item.image! as String,
                              fit: BoxFit.cover,
                            )
                          : Image.file(item.image! as File))),
            ),
            /*
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4),
              child: Text(
                product!.name!,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                "A partir de: R\$ ${product.basePrice.toStringAsFixed(2)}",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
           
            const SizedBox(height: 4),
             */
          ],
        ),
      ),
    );
  }
}
