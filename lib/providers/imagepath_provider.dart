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

  void setImagePathList(String value, int index) {
    if (index < _imagePaths.length) {
      _imagePaths[index] = value;
    } else {
      for (int i = _imagePaths.length; i <= index; i++) {
        _imagePaths.add('');
      }
      _imagePaths[index] = value;
    }
    notifyListeners();
  }

  void clearImages() {
    _imagePaths.clear();
    notifyListeners();
  }
}
