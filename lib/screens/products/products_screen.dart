import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/models/product_manager.dart';
import 'package:loja_virtual/screens/products/components/product_list_tile.dart';
import 'package:loja_virtual/screens/products/components/search_dialog.dart';
import 'package:provider/provider.dart';

import '../../models/user_manager.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.pushNamed(context, '/cart');
        },
        child: const Icon(Icons.shopping_cart_rounded),
      ),
      appBar: AppBar(
        title: Consumer<ProductManager>(
          builder: (_, productManager, __) {
            if (productManager.search.isEmpty) {
              return const Text("Produtos");
            } else {
              return LayoutBuilder(builder: (_, constraints) {
                return GestureDetector(
                  onTap: () async {
                    final search = await showDialog<String>(
                        context: context,
                        builder: (_) => SearchDialog(
                              initialText: productManager.search,
                            ));
                    if (search != null) {
                      // ignore: use_build_context_synchronously
                      productManager.search = search;
                    }
                  },
                  child: SizedBox(
                      width: constraints.biggest.width,
                      child: Text(
                        productManager.search,
                        textAlign: TextAlign.center,
                      )),
                );
              });
            }
          },
        ),
        centerTitle: true,
        actions: [
          Consumer<ProductManager>(
            builder: (_, productManager, __) {
              if (productManager.search.isEmpty) {
                return IconButton(
                    onPressed: () async {
                      final search = await showDialog<String>(
                          context: context,
                          builder: (_) => SearchDialog(
                                initialText: productManager.search,
                              ));
                      if (search != null) {
                        // ignore: use_build_context_synchronously
                        productManager.search = search;
                      }
                    },
                    icon: const Icon(Icons.search));
              } else {
                return IconButton(
                    onPressed: () async {
                      productManager.search = '';
                    },
                    icon: const Icon(Icons.close));
              }
            },
          ),
          Consumer<UserManager>(builder: (_, userManager, __) {
            if (userManager.adminEnabled) {
              return IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/edit_product',
                    );
                  },
                  icon: const Icon(Icons.add_circle_outline_rounded));
            } else {
              return Container();
            }
          }),
        ],
      ),
      body: Consumer<ProductManager>(builder: (_, productManager, __) {
        final filteredProducts = productManager.filteredProducts;
        return ListView.builder(
          itemCount: filteredProducts.length,
          itemBuilder: (_, index) {
            return ProductListTile(product: filteredProducts[index]);
          },
        );
      }),
    );
  }
}
