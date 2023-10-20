import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  ImageSourceSheet({required this.onImageSelected});

  final Function(File) onImageSelected;
  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return BottomSheet(
        enableDrag: true,
        showDragHandle: true,
        onClosing: () {},
        builder: (_) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.95,
                height: 45,
                child: ElevatedButton(
                  onPressed: () async {
                    final file =
                        await _picker.pickImage(source: ImageSource.camera);

                    onImageSelected(File(file!.path));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      )),
                  child: const Text('Camera'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.95,
                height: 45,
                child: ElevatedButton(
                  onPressed: () async {
                    final file =
                        await _picker.pickImage(source: ImageSource.gallery);

                    onImageSelected(File(file!.path));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      )),
                  child: const Text('Galeria'),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return CupertinoActionSheet(
        title: const Text("Selecionar Foto para o Item"),
        message: const Text("Escolha a Origem da Foto:"),
        cancelButton: CupertinoActionSheetAction(
          child: const Text(
            "Cancelar",
            style: TextStyle(color: CupertinoColors.destructiveRed),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () {},
              child: const Text("Câmera")),
          CupertinoActionSheetAction(
              onPressed: () {}, child: const Text("Galeria")),
        ],
      );
    }
  }
}
