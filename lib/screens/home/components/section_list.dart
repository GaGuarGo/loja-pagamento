import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/home/components/section_header.dart';

import '../../../models/section.dart';

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
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AspectRatio(
                              aspectRatio: 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  section.items![index].image!,
                                  fit: BoxFit.cover,
                                ),
                              )),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 4),
                          child: Text(
                            "Nome da Roupa",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            "R\$ 19.99",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
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
