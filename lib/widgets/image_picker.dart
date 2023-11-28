import 'dart:developer';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/imagepath_provider.dart';
import '../services/utils.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({
    super.key,
    required this.width,
  });

  final double width;

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  dynamic selectedImage;
  File? productImage;
  Uint8List webImage = Uint8List(8);
  String imagePath = '';
  ImagePathProvider imagePathProvider = ImagePathProvider();

  Future<void> pickImage() async {
    if (!kIsWeb) {
      final ImagePicker imagePicker = ImagePicker();
      XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          selectedImage = File(image.path);
          productImage = selectedImage;
          imagePath = image.path;
          imagePathProvider.setImagePath = imagePath;
          imagePathProvider.setImagePathList = imagePath;
        });
      } else {
        log('No image has been picked');
      }
    } else if (kIsWeb) {
      final ImagePicker imagePicker = ImagePicker();
      XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        Uint8List f = await image.readAsBytes();
        setState(() {
          selectedImage = f;
          webImage = selectedImage;
          imagePath = image.path;
          imagePathProvider.setImagePath = imagePath;
          imagePathProvider.setImagePathList = imagePath;
        });
      } else {
        log('No image has been picked');
      }
    } else {
      log('Something went wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: size.width > 650 ? widget.width : size.width * 0.45,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () async {
              await pickImage();
            },
            child: selectedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: kIsWeb
                        ? Image.memory(
                            webImage,
                            fit: BoxFit.contain,
                          )
                        : Image.file(
                            productImage!,
                            fit: BoxFit.contain,
                          ),
                  )
                : DottedBorder(
                    dashPattern: const [6.7],
                    borderType: BorderType.RRect,
                    color: color,
                    radius: const Radius.circular(12),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_outlined,
                            color: color,
                            size: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
