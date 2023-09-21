import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/home/components/item_tile.dart';
import 'package:loja_virtual/screens/home/components/section_header.dart';

import '../../../models/section.dart';

class SectionStaggered extends StatelessWidget {
  final Section section;

  const SectionStaggered({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(section: section),
          SizedBox(
            height: 350,
            child: GridView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: section.items!.length,
              itemBuilder: (context, index) {
                return ItemTile(
                  item: section.items![index],
                  type: "Staggered",
                );
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 4),
            ),
          ),
        ],
      ),
    );
  }
}
