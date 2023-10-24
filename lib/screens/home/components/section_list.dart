import 'package:flutter/material.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:loja_virtual/screens/home/components/section_header.dart';
import 'package:provider/provider.dart';

import '../../../models/section.dart';
import 'add_tile_widget.dart';
import 'item_tile.dart';

class SectionList extends StatelessWidget {
  final Section section;

  const SectionList({super.key, required this.section});

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
            SizedBox(
              height: 200,
              child: Consumer<Section>(
                builder: (_, section, __) {
                  return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, index) {
                        if (index < section.items!.length) {
                          return ItemTile(
                            item: section.items![index],
                            type: 'List',
                          );
                        } else {
                          return AddTileWidget();
                        }
                      },
                      separatorBuilder: (_, __) => const SizedBox(width: 4),
                      itemCount: homeManager.editing
                          ? section.items!.length + 1
                          : section.items!.length);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
