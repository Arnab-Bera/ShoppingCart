import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  // final String id;
  // final String title;
  // final String imageUrl;

  // const ProductItem(this.id, this.title, this.imageUrl, {Key? key})
  //     : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final product = Provider.of<Product>(context, listen: true);

    // return ClipRRect(
    //   borderRadius: BorderRadius.circular(10),
    //   child: GridTile(
    //     child: GestureDetector(
    //       onTap: () {
    //         Navigator.of(context).pushNamed(
    //           ProductDetailScreen.routeName,
    //           arguments: product.id,
    //         );
    //       },
    //       child: Image.network(
    //         product.imageUrl,
    //         fit: BoxFit.cover,
    //       ),
    //     ),
    //     footer: GridTileBar(
    //       backgroundColor: Colors.black87,
    //       leading: IconButton(
    //         icon: Icon(
    //             product.isFavorite ? Icons.favorite : Icons.favorite_outline),
    //         onPressed: () {
    //           product.toggleFavoriteStatus();
    //         },
    //         color: Theme.of(context).accentColor,
    //       ),
    //       title: Text(
    //         product.title,
    //         textAlign: TextAlign.center,
    //       ),
    //       trailing: IconButton(
    //         icon: const Icon(Icons.shopping_cart),
    //         onPressed: () {},
    //         color: Theme.of(context).accentColor,
    //       ),
    //     ),
    //   ),
    // );

    // return Consumer<Product>(
    //   builder: ((context, product, child) {
    //     return ClipRRect(
    //       borderRadius: BorderRadius.circular(10),
    //       child: GridTile(
    //         child: GestureDetector(
    //           onTap: () {
    //             Navigator.of(context).pushNamed(
    //               ProductDetailScreen.routeName,
    //               arguments: product.id,
    //             );
    //           },
    //           child: Image.network(
    //             product.imageUrl,
    //             fit: BoxFit.cover,
    //           ),
    //         ),
    //         footer: GridTileBar(
    //           backgroundColor: Colors.black87,
    //           leading: IconButton(
    //             icon: Icon(product.isFavorite
    //                 ? Icons.favorite
    //                 : Icons.favorite_outline),
    //             onPressed: () {
    //               product.toggleFavoriteStatus();
    //             },
    //             color: Theme.of(context).accentColor,
    //           ),
    //           title: Text(
    //             product.title,
    //             textAlign: TextAlign.center,
    //           ),
    //           trailing: IconButton(
    //             icon: const Icon(Icons.shopping_cart),
    //             onPressed: () {},
    //             color: Theme.of(context).accentColor,
    //           ),
    //         ),
    //       ),
    //     );
    //   }),
    // );

    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    print('Rebuilds!!');

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder:
                  const AssetImage('assets/images/product_placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          // child: FadeInImage(
          //   placeholder:
          //       const AssetImage('assets/images/product_placeholder.png'),
          //   image: NetworkImage(product.imageUrl),
          //   fit: BoxFit.cover,
          // ),
          // child: Image.network(
          //   product.imageUrl,
          //   fit: BoxFit.cover,
          // ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (context, product, _) => IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_outline,
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
                product.toggleFavoriteStatus(
                  authData.token,
                  authData.userId,
                );
              },
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.title, product.price);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Added item to cart!'),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
