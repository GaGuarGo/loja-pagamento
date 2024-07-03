import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:provider/provider.dart';

import '../../models/user_manager.dart';
import 'components/add_section_widget.dart';
import 'components/section_list.dart';
import 'components/section_staggered.dart';

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
                      )),
                  Consumer2<UserManager, HomeManager>(
                    builder: (_, userManager, homeManager, __) {
                      if (userManager.adminEnabled && !homeManager.loading) {
                        if (homeManager.editing) {
                          return PopupMenuButton(onSelected: (e) {
                            if (e == 'Salvar') {
                              homeManager.saveEditing();
                            } else {
                              homeManager.discardEditing();
                            }
                          }, itemBuilder: (_) {
                            return ['Salvar', 'Descartar']
                                .map((e) => PopupMenuItem(
                                      child: Text(e),
                                      value: e,
                                    ))
                                .toList();
                          });
                        } else {
                          return IconButton(
                              onPressed: homeManager.enterEditing,
                              icon: Icon(Icons.edit));
                        }
                      }
                      return Container();
                    },
                  ),
                ],
                snap: true,
                floating: true,
                flexibleSpace: const FlexibleSpaceBar(
                  title: Text("Loja do Gabriel"),
                  centerTitle: false,
                ),
              ),
              Consumer<HomeManager>(builder: (_, homeManager, __) {
                if (homeManager.loading) {
                  return SliverToBoxAdapter(
                    child: LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                      backgroundColor: Colors.transparent,
                    ),
                  );
                }

                final List<Widget> children =
                    homeManager.sections.map<Widget>((section) {
                  switch (section.type) {
                    case 'List':
                      return SectionList(section: section);
                    case 'Staggered':
                      return SectionStaggered(section: section);
                    default:
                      return Container();
                  }
                }).toList();

                if (homeManager.editing) children.add(AddSectionWidget());

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
