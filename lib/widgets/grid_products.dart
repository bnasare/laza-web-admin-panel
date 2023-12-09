import 'package:flutter/material.dart';
import 'package:laza_web_admin_panel/models/product_model.dart';
import 'package:laza_web_admin_panel/providers/product_provider.dart';
import 'package:provider/provider.dart';

import '../consts/constants.dart';
import 'products_widget.dart';

class ProductGridWidget extends StatelessWidget {
  const ProductGridWidget(
      {Key? key,
      this.crossAxisCount = 4,
      this.childAspectRatio = 1,
      this.isInMain = true,
      required this.products})
      : super(key: key);
  final int crossAxisCount;
  final double childAspectRatio;
  final bool isInMain;
  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: defaultPadding,
          mainAxisSpacing: defaultPadding,
        ),
        itemBuilder: (context, index) {
          ProductModel product = products[index];
          return ProductWidget(
            name: product.name,
            price: product.price,
            imagePath: product.productImages.first,
            brand: product.brand,
          );
        });
  }
}
