import 'package:flutter/material.dart';

class ProductModel with ChangeNotifier {
  final String id;
  final String name;
  final String category;
  final double price;
  final String description;
  final String brand;
  final List<dynamic> productImages;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.brand,
    required this.productImages,
  });
}
