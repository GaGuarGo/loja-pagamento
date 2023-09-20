import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      body: Stack(
        children: [
          // SE QUISER FAZER DEGRADE NA TELA

          // Container(
          //   decoration: const BoxDecoration(
          //     gradient: LinearGradient(colors: [

          //     ])
          //   ),
          // ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                actions: [
                  IconButton(
                      onPressed: () => Navigator.of(context).pushNamed('/cart'),
                      icon: const Icon(
                        Icons.shopping_cart_rounded,
                        color: Colors.white,
                      ))
                ],
                snap: true,
                floating: true,
                flexibleSpace: const FlexibleSpaceBar(
                  title: Text("Loja do Gabriel"),
                  centerTitle: true,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 2000,
                  width: 200,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
