import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_keeper_app/presentation/screens/add_product_screen.dart';
import 'package:store_keeper_app/presentation/widgets/product_card.dart';
import 'package:store_keeper_app/provider/product_provider.dart';
import 'package:store_keeper_app/services/permission_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    PermissionServices.initPermissions();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).getAllProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: Text('My Inventory')),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          final products = provider.products;

          if (products.isEmpty) {
            return const Center(child: Text('No products yet.'));
          }

          return GridView.builder(
            itemCount: products.length,
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 250,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 3 / 4,
            ),
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(product: product);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AddProductScreen.path);
        },
        shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
    );
  }
}
