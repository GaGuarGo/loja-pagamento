import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/product.dart';
import 'image_source_sheet.dart';

class ImagesForm extends StatelessWidget {
  final Product product;
  const ImagesForm({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return FormField<List<dynamic>>(
      initialValue: List.from(product.images as Iterable),
      onSaved: (images) => product.newImages = images,
      validator: (images) {
        if (images!.isEmpty) {
          return 'Insira ao menos uma imagem';
        }
        return null;
      },
      builder: (state) {
        void onImageSelected(File file) {
          state.value?.add(file);
          state.didChange(state.value);
          Navigator.of(context).pop();
        }

        return Column(
          children: [
            CarouselSlider(
              items: state.value?.map<Widget>((image) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    if (image is String)
                      Image.network(
                        image,
                        fit: BoxFit.cover,
                      )
                    else
                      Image.file(
                        image as File,
                        fit: BoxFit.cover,
                      ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          state.value?.remove(image);
                          state.didChange(state.value);
                        },
                        icon: const Icon(Icons.remove),
                        color: Colors.red,
                      ),
                    ),
                  ],
                );
              }).toList()
                ?..add(Container(
                  color: Colors.grey.shade100,
                  width: MediaQuery.of(context).size.width,
                  child: IconButton(
                    icon: const Icon(Icons.add_a_photo),
                    color: Theme.of(context).primaryColor,
                    iconSize: 50,
                    onPressed: () {
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
                  ),
                )),
              options: CarouselOptions(
                  viewportFraction: 1,
                  enlargeCenterPage: true,
                  aspectRatio: 1,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  disableCenter: false),
            ),
            if (state.hasError)
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 16, left: 16),
                child: Text(
                  state.errorText!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              )
          ],
        );
      },
    );
  }
}
