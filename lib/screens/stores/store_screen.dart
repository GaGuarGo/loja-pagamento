import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/models/stores_manager.dart';
import 'package:loja_virtual/screens/stores/components/store_card.dart';
import 'package:provider/provider.dart';

class StoresScreen extends StatelessWidget {
  const StoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text("Lojas"),
        centerTitle: true,
      ),
      body: Consumer<StoresManager>(
        builder: (_, storesManager, __) {
          if (storesManager.loading) {
            return LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
              backgroundColor: Colors.transparent,
            );
          }
          return ListView.builder(
            itemCount: storesManager.stores.length,
            itemBuilder: (context, index) {
              return StoreCard(store: storesManager.stores[index]);
            },
          );
        },
      ),
    );
  }
}
