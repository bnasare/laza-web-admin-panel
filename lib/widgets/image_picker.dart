import 'dart:developer';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/imagepath_provider.dart';
import '../services/utils.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({
    super.key,
    required this.width,
    required this.index,
    required this.imagePathProvider,
  });

  final double width;
  final int index;
  final ImagePathProvider imagePathProvider;

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  dynamic selectedImage;
  File? productImage;
  Uint8List webImage = Uint8List(8);
  String imagePath = '';

  Future<void> pickImage() async {
    if (!kIsWeb) {
      final ImagePicker imagePicker = ImagePicker();
      XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        File? imageFile = File(image.path);
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        final Reference storageReference =
            FirebaseStorage.instance.ref().child('products/$fileName');
        final UploadTask uploadTask = storageReference.putFile(imageFile);
        final String url = await (await uploadTask).ref.getDownloadURL();
        setState(() {
          selectedImage = File(image.path);
          productImage = selectedImage;
          imagePath = url;
        });
        widget.imagePathProvider.setImagePathList(imagePath, widget.index);
      } else {
        log('No image has been picked');
      }
    } else if (kIsWeb) {
      final ImagePicker imagePicker = ImagePicker();
      XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        Uint8List f = await image.readAsBytes();
        var now = DateTime.now().millisecondsSinceEpoch;
        Reference reference =
            FirebaseStorage.instance.ref().child("products/$now");
        final UploadTask uploadTask = reference.putData(f);
        final String url = await (await uploadTask).ref.getDownloadURL();
        setState(() {
          selectedImage = f;
          webImage = selectedImage;
          imagePath = url;
        });
        widget.imagePathProvider.setImagePathList(imagePath, widget.index);
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
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            productImage!,
                            fit: BoxFit.cover,
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
