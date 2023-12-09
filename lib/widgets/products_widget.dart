import 'package:flutter/material.dart';

import '../services/utils.dart';
import 'text_widget.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({
    Key? key,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.brand,
  }) : super(key: key);

  final String name;
  final double price;
  final String imagePath;
  final String brand;

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;

    final color = Utils(context).color;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor.withOpacity(0.6),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Image.network(
                        imagePath,
                        fit: BoxFit.contain,
                        // width: screenWidth * 0.12,
                        height: size.width * 0.12,
                      ),
                    ),
                    const Spacer(),
                    PopupMenuButton(
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                onTap: () {},
                                value: 1,
                                child: const Text('Edit'),
                              ),
                              PopupMenuItem(
                                onTap: () {},
                                value: 2,
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ])
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    TextWidget(
                      text: '\$$price.00',
                      color: color,
                      textSize: 12,
                    ),
                    const Spacer(),
                    TextWidget(
                      text: brand,
                      color: color,
                      textSize: 12,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                TextWidget(
                  text: name,
                  color: color,
                  textSize: 18,
                  isTitle: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
