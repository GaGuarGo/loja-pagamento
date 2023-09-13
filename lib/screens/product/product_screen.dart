import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../models/product.dart';
import 'components/size_widget.dart';

class ProductScreen extends StatelessWidget {
  final Product product;

  const ProductScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(product.name!),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          CarouselSlider(
            items: product.images!.map((url) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                ),
              );
            }).toList(),
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name!,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'A partir de',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ),
                Text(
                  "R\$ 19,99",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8, top: 16),
                  child: Text(
                    'Descrição',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  product.description!,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8, top: 16),
                  child: Text(
                    'Tamanhos:',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  runAlignment: WrapAlignment.spaceEvenly,
                  children: product.sizes!.map((s) {
                    return SizeWidget(size: s);
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
