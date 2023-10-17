import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../models/product.dart';

class ImagesForm extends StatelessWidget {
  final Product product;
  const ImagesForm({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return FormField<List<dynamic>>(
      initialValue: product.images,
      builder: (state) {
        return CarouselSlider(
          items: state.value?.map((image) {
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
          }).toList() as List<Widget>,
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
        );
      },
    );
  }
}
