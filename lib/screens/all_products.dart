import 'package:flutter/material.dart';
import 'package:my_store/components/appDrawer.dart';
import 'package:my_store/components/badge_Item.dart';
import 'package:my_store/components/product_grid.dart';
import 'package:my_store/models/cart.dart';
import 'package:my_store/models/product_list.dart';
import 'package:my_store/utils/routes.dart';
import 'package:provider/provider.dart';

enum FilterOptions {
  // ignore: constant_identifier_names
  Only,
  // ignore: constant_identifier_names
  All,
}

class AllProducts extends StatefulWidget {
  const AllProducts({super.key});

  @override
  State<AllProducts> createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  bool showFavoriteOnly = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductList>(context, listen: false).loadProducts().then((
      param,
    ) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos os Produtos'),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Only) {
                  showFavoriteOnly = true;
                  return;
                }

                showFavoriteOnly = false;
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: FilterOptions.Only,
                child: Text("Somente favoritos"),
              ),
              PopupMenuItem(
                value: FilterOptions.All,
                child: Text("Todos os produtos"),
              ),
            ],
          ),
          Consumer<Cart>(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.cart);
              },
              icon: Icon(Icons.shopping_cart),
            ),
            builder: (ctx, cart, child) => BadgeItem(
              value: cart.itemsCount.toString(),
              color: Colors.green,
              child: child!,
            ),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 8),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : ProductGrid(showFavoriteOnly),
      ),
      drawer: AppDrawer(),
    );
  }
}
