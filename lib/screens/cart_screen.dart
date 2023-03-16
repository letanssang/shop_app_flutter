import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var isOrdering = false;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: isOrdering
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(15),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(fontSize: 20),
                        ),
                        const Spacer(),
                        Chip(
                          label: Text(
                            '\$${cart.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.blue,
                        ),
                        cart.items.isEmpty
                            ? const TextButton(
                                onPressed: null,
                                child: Text(
                                  'ORDER NOW',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            : TextButton(
                                onPressed: () async {
                                  try {
                                    setState(() {
                                      isOrdering = true;
                                    });
                                    await Provider.of<Orders>(context,
                                            listen: false)
                                        .addOrder(cart.items.values.toList(),
                                            cart.totalAmount);
                                    cart.clear();
                                  } catch (error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Ordering failed!'),
                                      ),
                                    );
                                  }
                                  setState(() {
                                    isOrdering = false;
                                  });
                                },
                                child: const Text(
                                  'ORDER NOW',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: cart.items.length,
                      itemBuilder: (ctx, i) => CartItem(
                            id: cart.items.values.toList()[i].id,
                            title: cart.items.values.toList()[i].title,
                            price: cart.items.values.toList()[i].price,
                            quantity: cart.items.values.toList()[i].quantity,
                            productId: cart.items.keys.toList()[i],
                          )),
                )
              ],
            ),
    );
  }
}
