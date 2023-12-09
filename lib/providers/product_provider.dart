import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductProvider with ChangeNotifier {
  final List<ProductModel> _products = [];

  List<ProductModel> get products => _products;

  Future<void> getProducts() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection("products").get();
      _products.clear();

      for (final doc in snapshot.docs) {
        ProductModel product = ProductModel(
          id: doc['id'] as String? ?? 'NULL_ID',
          name: doc['name'] as String? ?? 'NULL_NAME',
          category: doc['category'] as String? ?? 'NULL_CATEGORY',
          price: doc['price'] as double? ?? 0.00,
          description: doc['description'] as String? ?? 'NULL_DESCRIPTION',
          brand: doc['brand'] as String? ?? 'NULL_BRAND',
          productImages: doc['imagePaths'] as List<dynamic>? ?? [],
        );
        _products.add(product);
      }
      notifyListeners();
    } catch (error) {
      log('Error: $error');
    }
  }
}
