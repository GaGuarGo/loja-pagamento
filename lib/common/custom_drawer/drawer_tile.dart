import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loja_virtual/models/page_manager.dart';
import 'package:provider/provider.dart';

class DrawerTile extends StatelessWidget {
  final IconData iconData;
  final String title;
  final int page;

  const DrawerTile(
      {super.key,
      required this.iconData,
      required this.title,
      required this.page});

  @override
  Widget build(BuildContext context) {
    final int curPage = context.watch<PageManager>().page;

    return InkWell(
      onTap: () {
        context.read<PageManager>().setPage(page);
      },
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Icon(iconData,
                  size: 32,
                  color: curPage == page ? Colors.blue : Colors.grey.shade700),
            ),
            Text(
              title,
              style: TextStyle(
                  fontSize: 16,
                  color: curPage == page ? Colors.blue : Colors.grey.shade700),
            )
          ],
        ),
      ),
    );
  }
}
