import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:screenshot/screenshot.dart';
import 'package:permission_handler/permission_handler.dart';

class ExportAddressDialog extends StatelessWidget {
  ExportAddressDialog(this.address);

  final Address address;
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Endereço de Entrega',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      content: Screenshot(
        controller: screenshotController,
        child: Container(
          padding: const EdgeInsets.all(8),
          color: Colors.white,
          child: Text(
            '${address.street}, ${address.number} ${address.complement}\n'
            '${address.district}\n'
            '${address.city}/${address.state}\n'
            '${address.zipCode}',
          ),
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            bool androidExistNotSave = false;
            bool isGranted;

            if (Platform.isAndroid) {
              final deviceInfoPlugin = DeviceInfoPlugin();
              final deviceInfo = await deviceInfoPlugin.androidInfo;
              final sdkInt = deviceInfo.version.sdkInt;

              if (androidExistNotSave == true) {
                isGranted =
                    await (sdkInt > 33 ? Permission.photos : Permission.storage)
                        .request()
                        .isGranted;
              } else {
                isGranted = sdkInt < 29
                    ? await Permission.storage.request().isGranted
                    : true;
              }
            } else {
              isGranted = await Permission.photosAddOnly.request().isGranted;
            }

            if (isGranted) {
              screenshotController
                  .capture(delay: const Duration(milliseconds: 10))
                  .then((Uint8List? image) async {
                if (image != null) {
                  await SaverGallery.saveImage(
                    image,
                    name: 'Endereço Pedido',
                    androidExistNotSave: androidExistNotSave,
                  );
                }
              }).catchError((onError) {
                if (kDebugMode) {
                  print(onError);
                }
              });
            } else {
              if (kDebugMode) {
                print("Não tem permissão");
              }
            }
          },
          child: const Text('Exportar'),
        )
      ],
    );
  }
}
