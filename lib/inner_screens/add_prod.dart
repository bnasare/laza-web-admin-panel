import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../controllers/MenuController.dart';
import '../providers/imagepath_provider.dart';
import '../responsive.dart';
import '../services/utils.dart';
import '../widgets/buttons.dart';
import '../widgets/header.dart';
import '../widgets/image_picker.dart';
import '../widgets/side_menu.dart';
import '../widgets/text_widget.dart';

class UploadProductForm extends StatefulWidget {
  static const routeName = '/UploadProductForm';

  const UploadProductForm({super.key});

  @override
  _UploadProductFormState createState() => _UploadProductFormState();
}

class _UploadProductFormState extends State<UploadProductForm> {
  final _formKey = GlobalKey<FormState>();
  String _catValue = 'Male';
  String _brandValue = 'Nike';
  late final TextEditingController _titleController,
      _priceController,
      _descriptionController;
  bool isPiece = false;
  Uint8List webImage = Uint8List(8);

  @override
  void initState() {
    _priceController = TextEditingController();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Utils(context).color;
    final scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    Size size = Utils(context).getScreenSize;
    final ImagePathProvider imagePathProvider =
        Provider.of<ImagePathProvider>(context, listen: false);

    Future<void> uploadToFirebase() async {
      try {
        final String uuid = const Uuid().v4();
        final List<String> imagePathList = imagePathProvider.getImagePaths;
        await FirebaseFirestore.instance.collection('products').doc(uuid).set({
          'id': uuid,
          'name': _titleController.text,
          'price': double.parse(_priceController.text),
          'category': _catValue,
          'brand': _brandValue,
          'description': _descriptionController.text,
          'imagePaths': imagePathList,
        });
        log('Uploaded');
      } catch (error) {
        log('Error: $error');
      }
    }

    void uploadForm() async {
      final isValid = _formKey.currentState!.validate();
      await uploadToFirebase();
    }

    void clearForm() {
      _priceController.clear();
      _titleController.clear();
      _descriptionController.clear();
      imagePathProvider.clearImages();
    }

    var inputDecoration = InputDecoration(
      filled: true,
      fillColor: scaffoldColor,
      border: InputBorder.none,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 1.0,
        ),
      ),
    );
    return Scaffold(
      key: context.read<MenuControllerr>().getAddProductscaffoldKey,
      drawer: const SideMenu(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (Responsive.isDesktop(context))
            const Expanded(
              child: SideMenu(),
            ),
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Header(
                        fct: () {
                          context
                              .read<MenuControllerr>()
                              .controlAddProductsMenu();
                        },
                        title: 'Add product',
                        showTexField: false),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    width: size.width > 650 ? 800 : size.width,
                    color: Theme.of(context).cardColor,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextWidget(
                            text: 'Product title*',
                            color: color,
                            isTitle: true,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _titleController,
                            key: const ValueKey('Title'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a Title';
                              }
                              return null;
                            },
                            decoration: inputDecoration,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: FittedBox(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      TextWidget(
                                        text: 'Price in \$*',
                                        color: color,
                                        isTitle: true,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: TextFormField(
                                          controller: _priceController,
                                          key: const ValueKey('Price \$'),
                                          keyboardType: TextInputType.number,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Price is missed';
                                            }
                                            return null;
                                          },
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9.]'),
                                            ),
                                          ],
                                          decoration: inputDecoration,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      TextWidget(
                                        text: 'Product category*',
                                        color: color,
                                        isTitle: true,
                                      ),
                                      const SizedBox(height: 10),
                                      // Drop down menu code here
                                      _categoryDropDown(),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextWidget(
                                        text: 'Product brand*',
                                        color: color,
                                        isTitle: true,
                                      ),
                                      const SizedBox(height: 10),
                                      _brandDropDown(),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Image to be picked code is here
                              Expanded(
                                flex: 4,
                                child: ImagePickerWidget(
                                  width: 350,
                                  index: 0,
                                  imagePathProvider: imagePathProvider,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: FittedBox(
                                  child: Column(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            webImage = Uint8List(8);
                                          });
                                        },
                                        child: TextWidget(
                                          text: 'Clear',
                                          color: Colors.red,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {},
                                        child: TextWidget(
                                          text: 'Update image',
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextWidget(
                            text: 'Other Images*',
                            color: color,
                            isTitle: true,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 8),
                            child: SizedBox(
                              height: 250,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 4,
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                    height: 180,
                                    width: 180,
                                    child: ImagePickerWidget(
                                      width: 180,
                                      index: index + 1,
                                      imagePathProvider: imagePathProvider,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          TextWidget(
                            text: 'Description*',
                            color: color,
                            isTitle: true,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            maxLines: 5,
                            maxLength: 600,
                            controller: _descriptionController,
                            key: const ValueKey('Description'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a description';
                              }
                              return null;
                            },
                            decoration: inputDecoration,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ButtonsWidget(
                                  onPressed: clearForm,
                                  text: 'Clear form',
                                  icon: IconlyBold.danger,
                                  backgroundColor: Colors.red.shade300,
                                ),
                                ButtonsWidget(
                                  onPressed: () {
                                    uploadForm();
                                  },
                                  text: 'Upload',
                                  icon: IconlyBold.upload,
                                  backgroundColor: Colors.blue,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryDropDown() {
    final color = Utils(context).color;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
            value: _catValue,
            onChanged: (catValue) {
              setState(() {
                _catValue = catValue!;
              });
              log(_catValue);
            },
            hint: const Text('Select a category'),
            items: const [
              DropdownMenuItem(
                value: 'Male',
                child: Text(
                  'Male',
                ),
              ),
              DropdownMenuItem(
                value: 'Female',
                child: Text(
                  'Female',
                ),
              ),
              DropdownMenuItem(
                value: 'Unisex',
                child: Text(
                  'Unisex',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _brandDropDown() {
    final color = Utils(context).color;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
            value: _brandValue,
            onChanged: (value) {
              setState(() {
                _brandValue = value!;
              });
              log(_brandValue);
            },
            hint: const Text('Select a category'),
            items: const [
              DropdownMenuItem(
                value: 'Nike',
                child: Text(
                  'Nike',
                ),
              ),
              DropdownMenuItem(
                value: 'Adidas',
                child: Text(
                  'Adidas',
                ),
              ),
              DropdownMenuItem(
                value: 'Fila',
                child: Text(
                  'Fila',
                ),
              ),
              DropdownMenuItem(
                value: 'Jordan',
                child: Text(
                  'Jordan',
                ),
              ),
              DropdownMenuItem(
                value: 'Puma',
                child: Text(
                  'Puma',
                ),
              ),
              DropdownMenuItem(
                value: 'Under Armour',
                child: Text(
                  'UnderArmour',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
