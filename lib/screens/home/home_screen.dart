import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:loja_virtual/models/section.dart';
import 'package:provider/provider.dart';

import 'components/section_list.dart';

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
              Consumer<HomeManager>(builder: (_, homeManager, __) {
                final List<Widget> children =
                    homeManager.sections.map<Widget>((section) {
                  switch (section.type) {
                    case 'List':
                      return SectionList(
                        section: section,
                      );
                    case 'Staggered':
                      return Container();
                    default:
                      return Container();
                  }
                }).toList();

                return SliverList(
                  delegate: SliverChildListDelegate(children),
                );
              })
            ],
          ),
        ],
      ),
    );
  }
}
