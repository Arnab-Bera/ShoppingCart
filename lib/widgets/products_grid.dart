import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

import '../widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  const ProductsGrid(this.showFavs, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context, listen: true);
    final products = showFavs ? productsData.favoriteItems : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      // itemBuilder: (context, index) => ChangeNotifierProvider(
      //   create: (context) => products[index],
      //   child: const ProductItem(
      //       // products[index].id,
      //       // products[index].title,
      //       // products[index].imageUrl,
      //       ),
      // ),
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: const ProductItem(
            // products[index].id,
            // products[index].title,
            // products[index].imageUrl,
            ),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
