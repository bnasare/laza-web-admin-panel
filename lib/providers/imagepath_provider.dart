import 'package:flutter/material.dart';

class ImagePathProvider with ChangeNotifier {
  String _imagePath = '';
  final List<String> _imagePaths = [];

  String get getImagePath => _imagePath;
  List<String> get getImagePaths => _imagePaths;

  set setImagePath(String value) {
    _imagePath = value;
    notifyListeners();
  }

  set setImagePathList(String value) {
    _imagePaths.add(value);
    notifyListeners();
  }

  void clearImages() {
    _imagePaths.clear();
    notifyListeners();
  }
}
