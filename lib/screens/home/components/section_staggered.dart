import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/home/components/item_tile.dart';
import 'package:loja_virtual/screens/home/components/section_header.dart';
import 'package:provider/provider.dart';

import '../../../models/home_manager.dart';
import '../../../models/section.dart';
import 'add_tile_widget.dart';

class SectionStaggered extends StatelessWidget {
  final Section section;

  const SectionStaggered({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();

    return ChangeNotifierProvider.value(
      value: section,
      child: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(),
            Consumer<Section>(builder: (_, section, __) {
              return SizedBox(
                height: 350,
                child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: homeManager.editing
                      ? section.items!.length + 1
                      : section.items!.length,
                  itemBuilder: (context, index) {
                    if (index < section.items!.length)
                      return ItemTile(
                        item: section.items![index],
                        type: "Staggered",
                      );
                    else
                      return AddTileWidget();
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, mainAxisSpacing: 4),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
