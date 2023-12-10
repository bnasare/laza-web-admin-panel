import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../consts/constants.dart';
import '../controllers/MenuController.dart';
import '../inner_screens/add_prod.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';
import '../responsive.dart';
import '../services/utils.dart';
import '../widgets/buttons.dart';
import '../widgets/grid_products.dart';
import '../widgets/header.dart';
import '../widgets/orders_list.dart';
import '../widgets/text_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late ProductProvider productProvider;

  @override
  void initState(){
    super.initState();
    productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    productProvider.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    Color color = Utils(context).color;
    final List<ProductModel> products = productProvider.products;
    return SafeArea(
      child: SingleChildScrollView(
        controller: ScrollController(),
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(
              fct: () {
                context.read<MenuControllerr>().controlDashboarkMenu();
              },
              title: 'Dashboard',
            ),
            const SizedBox(
              height: 20,
            ),
            TextWidget(
              text: 'Latest Products',
              color: color,
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ButtonsWidget(
                      onPressed: () {},
                      text: 'View All',
                      icon: Icons.store,
                      backgroundColor: Colors.blue),
                  const Spacer(),
                  ButtonsWidget(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UploadProductForm(),
                          ),
                        );
                      },
                      text: 'Add product',
                      icon: Icons.add,
                      backgroundColor: Colors.blue),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  // flex: 5,
                  child: Column(
                    children: [
                      Responsive(
                        mobile: ProductGridWidget(
                          crossAxisCount: size.width < 650 ? 2 : 4,
                          childAspectRatio:
                              size.width < 650 && size.width > 350 ? 1.1 : 0.8,
                          products: products,
                        ),
                        desktop: ProductGridWidget(
                          childAspectRatio: size.width < 1400 ? 0.8 : 1.05,
                          products: products,
                        ),
                      ),
                      const OrdersList(isInDashboard: true)
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
