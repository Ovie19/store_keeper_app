import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_keeper_app/data/models/product.dart';
import 'package:store_keeper_app/presentation/widgets/text_field.dart';
import 'package:store_keeper_app/provider/product_provider.dart';
import 'package:store_keeper_app/services/image_services.dart';
import 'package:store_keeper_app/utils/show_image_picker_options.dart';

import '../../utils/custom_dialog.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  static String path = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  File? image;
  final _formKey = GlobalKey<FormState>();
  late int _id;
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final product = ModalRoute.of(context)!.settings.arguments as Product;

      setState(() {
        _id = product.id!;
        image = File(product.imagePath);
        _nameController.text = product.name;
        _quantityController.text = '${product.quantity}';
        _priceController.text = '${product.price}';
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      try {
        final imagePath = await ImageServices.saveImage(image!);

        final product = Product(
          id: _id,
          name: _nameController.text,
          price: double.parse(_priceController.text),
          imagePath: imagePath,
          quantity: int.parse(_quantityController.text),
        );
        await Provider.of<ProductProvider>(
          context,
          listen: false,
        ).updateProduct(product);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Product updated')));
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }

      // Clear form
      _nameController.clear();
      _quantityController.clear();
      _priceController.clear();
      setState(() {
        image = null;
      });

      Navigator.popUntil(context, ModalRoute.withName('/'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(title: Text('Edit Product')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 15,
            children: [
              CustomTextField(
                controller: _nameController,
                hintText: 'Product Name',
              ),
              CustomTextField(
                controller: _quantityController,
                hintText: 'Quantity',
                keyboardType: TextInputType.number,
              ),
              CustomTextField(
                controller: _priceController,
                hintText: 'Price',
                keyboardType: TextInputType.number,
              ),

              GestureDetector(
                onTap: () => showImagePickerOptions(
                  context,
                  onCameraOption: () async {
                    Navigator.pop(context);
                    try {
                      final pickedImage =
                      await ImageServices.pickImageFromCamera();
                      if (pickedImage != null) {
                        setState(() {
                          image = pickedImage;
                        });
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error picking image: $e')),
                      );
                    }
                  },
                  onGaleryOption: () async {
                    Navigator.pop(context);
                    try {
                      final pickedImage =
                      await ImageServices.pickImageFromGallery();
                      if (pickedImage != null) {
                        setState(() {
                          image = pickedImage;
                        });
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error picking image: $e')),
                      );
                    }
                  },
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                          color: Colors.grey[50],
                        ),
                        child: image != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(image!, fit: BoxFit.cover),
                        )
                            : const Icon(
                          Icons.camera_alt_rounded,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        image == null ? 'Add Image' : 'Change Image',
                        style: TextStyle(color: Colors.grey, fontSize: 17),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    showConfirmDialog(
                      context: context,
                      message: 'Do you really want to make changes to this product?',
                      onConfirm: _updateProduct,
                    );
                  },
                  child: Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
