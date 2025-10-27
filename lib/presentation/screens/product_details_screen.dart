import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_keeper_app/data/models/product.dart';
import 'package:store_keeper_app/presentation/screens/edit_product_screen.dart';
import 'package:store_keeper_app/provider/product_provider.dart';
import 'package:store_keeper_app/utils/custom_dialog.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  static String path = '/product-details';

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(title: Text('Product Details')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Image.file(
              File(product.imagePath),
              height: MediaQuery.of(context).size.height * .45,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 15),
            Text(
              product.name,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 15),
            buildProductDetailsItem(
              name: 'Quantity',
              value: '${product.quantity}',
            ),
            SizedBox(height: 8),
            buildProductDetailsItem(name: 'Price', value: '${product.price}'),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pushNamed(EditProductScreen.path, arguments: product);
                    },
                    child: Text('Edit'),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => showConfirmDialog(
                      context: context,
                      message: 'Do you really want to delete this product? You will no be able to undo this action',
                      onConfirm: () {
                        context.read<ProductProvider>().deleteProduct(
                          product.id!,
                        );

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Product deleted successfully!!!')));
                      },
                    ),
                    style: ElevatedButton.styleFrom().copyWith(
                      backgroundColor: WidgetStatePropertyAll(Colors.red),
                    ),
                    child: Text('Delete'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProductDetailsItem({
    required String name,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: TextStyle(fontSize: 17, color: Colors.black87)),
        SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          readOnly: true,
        ),
      ],
    );
  }
}
