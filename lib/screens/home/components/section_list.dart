import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/home/components/section_header.dart';

import '../../../models/section.dart';
import 'item_tile.dart';

class SectionList extends StatelessWidget {
  final Section section;

  const SectionList({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(section: section),
          SizedBox(
            height: 200,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, index) {
                  return ItemTile(
                    item: section.items![index],
                    type: 'List',
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 4),
                itemCount: section.items!.length),
          ),
        ],
      ),
    );
  }
}
