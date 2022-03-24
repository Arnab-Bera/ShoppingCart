import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './helpers/custom_route.dart';

import './screens/splash_screen.dart';
import './screens/product_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';

import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';
import './providers/product.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),

        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products(null, null, []),
          update: (ctx, auth, previousProducts) {
            return Products(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.items,
            );
          },
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders(null, null, []),
          update: (ctx, auth, previousOrders) {
            return Orders(
              auth.token,
              auth.userId,
              previousOrders == null ? [] : previousOrders.orders,
            );
          },
        ),

        // ChangeNotifierProvider.value(
        //   value: Auth(),
        // ),
        // ChangeNotifierProvider.value(
        //   value: Products(),
        // ),
        // ChangeNotifierProvider.value(
        //   value: Cart(),
        // ),
        // ChangeNotifierProvider.value(
        //   value: Orders(),
        // ),
      ],
      child: Consumer<Auth>(
        builder: (context, authValue, _) => MaterialApp(
          title: 'My Shop',
          theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Quicksand',
              pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CustomPageTransitionBuilder(),
                  TargetPlatform.iOS: CustomPageTransitionBuilder(),
                },
              )),
          // home: authValue.isAuth
          //     ? const ProductsOverviewScreen()
          //     : const AuthScreen(),
          home: authValue.isAuth
              ? const ProductsOverviewScreen()
              : FutureBuilder(
                  future: authValue.tryAutoLogin(),
                  builder: (ctx, authSnapshot) {
                    print(authSnapshot.connectionState);
                    return authSnapshot.connectionState ==
                            ConnectionState.waiting
                        ? const SplashScreen()
                        : const AuthScreen();
                  }),
          routes: {
            // ProductsOverviewScreen.routeName: (ctx) =>
            //     const ProductsOverviewScreen(),
            ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
            CartScreen.routeName: (ctx) => const CartScreen(),
            OrdersScreen.routeName: (ctx) => const OrdersScreen(),
            UserProdcutsScreen.routeName: (ctx) => const UserProdcutsScreen(),
            EditProdcutScreen.routeName: (ctx) => const EditProdcutScreen(),
          },
        ),
      ),
    );

    // return ChangeNotifierProvider(
    //   create: (context) => Products(),
    //   child: MaterialApp(
    //     title: 'My Shop',
    //     theme: ThemeData(
    //       primarySwatch: Colors.purple,
    //       accentColor: Colors.deepOrange,
    //       fontFamily: 'Quicksand',
    //     ),
    //     home: const ProductsOverviewScreen(),
    //     routes: {
    //       ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
    //     },
    //   ),
    // );

    // return ChangeNotifierProvider.value(
    //   value: Products(),
    //   child: MaterialApp(
    //     title: 'My Shop',
    //     theme: ThemeData(
    //       primarySwatch: Colors.purple,
    //       accentColor: Colors.deepOrange,
    //       fontFamily: 'Quicksand',
    //     ),
    //     home: const ProductsOverviewScreen(),
    //     routes: {
    //       ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
    //     },
    //   ),
    // );
  }
}
