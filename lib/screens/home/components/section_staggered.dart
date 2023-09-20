import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
            height: 250,
            child: GridView.custom(
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              gridDelegate: SliverQuiltedGridDelegate(
                crossAxisCount: 4,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                repeatPattern: QuiltedGridRepeatPattern.inverted,
                pattern: const [
                  QuiltedGridTile(2, 2),
                  QuiltedGridTile(1, 1),
                  QuiltedGridTile(1, 1),
                  QuiltedGridTile(1, 2),
                ],
              ),
              scrollDirection: Axis.vertical,
              childrenDelegate: SliverChildBuilderDelegate(
                childCount: section.items!.length,
                (context, index) {
                  return Image.network(
                    section.items![index].image!,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
