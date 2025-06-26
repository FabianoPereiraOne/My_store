import 'package:flutter/material.dart';
import 'package:my_store/components/appDrawer.dart';
import 'package:my_store/components/product_controller.dart';
import 'package:my_store/models/product_list.dart';
import 'package:my_store/utils/routes.dart';
import 'package:provider/provider.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  Future<void> refreshProducts(BuildContext context) async {
    Provider.of<ProductList>(context, listen: false).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final ProductList products = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Gerenciar Produtos"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.productsForm);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: products.itemsCount,
            itemBuilder: (ctx, index) {
              return Column(
                children: [
                  ProductController(products.items[index]),
                  Divider(color: const Color.fromARGB(255, 216, 214, 214)),
                ],
              );
            },
          ),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
