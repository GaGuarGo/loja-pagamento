import 'package:flutter/material.dart';
import 'package:loja_virtual/models/product.dart';

class ProductListTile extends StatelessWidget {
  final Product product;

  const ProductListTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/product', arguments: product);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Image.network(product.images!.first),
              ),
              const SizedBox(width: 16),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name!,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'A partir de',
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade400),
                    ),
                  ),
                  Text(
                    "R\$ ${product.basePrice.toStringAsFixed(2)}",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).primaryColor),
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
