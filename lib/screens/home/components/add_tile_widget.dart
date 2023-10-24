import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/section_item.dart';
import 'package:provider/provider.dart';
import '../../../models/section.dart';
import '../../edit_product/components/image_source_sheet.dart';

class AddTileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final section = context.watch<Section>();

    void onImageSelected(File file) {
      section.addItem(SectionItem(image: file));
      Navigator.of(context).pop();
    }

    return AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        onTap: () {
          if (Platform.isAndroid) {
            showModalBottomSheet(
                context: context,
                builder: (_) => ImageSourceSheet(
                      onImageSelected: onImageSelected,
                    ));
          } else {
            showCupertinoModalPopup(
                context: context,
                builder: (_) => ImageSourceSheet(
                      onImageSelected: onImageSelected,
                    ));
          }
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white.withAlpha(30),
              borderRadius: BorderRadius.circular(8)),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
