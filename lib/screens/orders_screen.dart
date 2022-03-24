import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;

import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // var _isLoading = false;

  // @override
  // void initState() {
  //   // Future.delayed(Duration.zero).then((_) async {
  //   //   setState(() {
  //   //     _isLoading = true;
  //   //   });
  //   //   await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  //   //   setState(() {
  //   //     _isLoading = false;
  //   //   });
  //   // });

  //   // _isLoading = true;
  //   // Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then((_) {
  //   //   setState(() {
  //   //     _isLoading = false;
  //   //   });
  //   // });

  //   super.initState();
  // }

  late Future _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('My Orders'),
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.error != null) {
                return const Center(
                  child: Text('An error occured!'),
                );
              } else {
                return Consumer<Orders>(
                  builder: (ctx, orderData, child) {
                    return ListView.builder(
                      itemBuilder: (context, index) =>
                          OrderItem(orderData.orders[index]),
                      itemCount: orderData.orders.length,
                    );
                  },
                );
              }
            }
          },

          future: _ordersFuture,
          // future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        )

        // body: _isLoading
        //     ? const Center(
        //         child: CircularProgressIndicator(),
        //       )
        //     : ListView.builder(
        //         itemBuilder: (context, index) =>
        //             OrderItem(orderData.orders[index]),
        //         itemCount: orderData.orders.length,
        //       ),
        );
  }
}
