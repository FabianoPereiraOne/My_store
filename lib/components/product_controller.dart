import 'package:flutter/material.dart';
import 'package:my_store/models/product.dart';
import 'package:my_store/models/product_list.dart';
import 'package:my_store/utils/routes.dart';
import 'package:provider/provider.dart';

class ProductController extends StatelessWidget {
  final Product product;
  const ProductController(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    final alert = ScaffoldMessenger.of(context);

    return ListTile(
      title: Text(product.title),
      leading: CircleAvatar(backgroundImage: NetworkImage(product.imageUrl)),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).pushNamed(AppRoutes.productsForm, arguments: product);
              },
              icon: Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () async {
                bool confirm = await showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      title: Text("Tem certeza?"),
                      content: Text("Deseja realmente excluir o produto?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop(true);
                          },
                          child: Text("Sim"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop(false);
                          },
                          child: Text("Não"),
                        ),
                      ],
                    );
                  },
                );

                if (!confirm) return;

                try {
                  Provider.of<ProductList>(
                    context,
                    listen: false,
                  ).removeProduct(product);
                } catch (error) {
                  alert.showSnackBar(SnackBar(content: Text(error.toString())));
                }
              },
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
