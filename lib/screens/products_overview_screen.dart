import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import 'cart_screen.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch!,
              label: Text(cart.itemCount.toString()),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  // products.showFavoritesOnly();
                  _showOnlyFavorites = true;
                } else {
                  // products.showAll();
                  _showOnlyFavorites = false;
                }
              });
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                  child: Text('Only Favorites'),
                  value: FilterOptions.Favorites),
              const PopupMenuItem(
                  child: Text('Show All'), value: FilterOptions.All),
            ],
            icon: const Icon(Icons.more_vert),
          ),

        ],
      ),
      body: ProductsGrid(_showOnlyFavorites),
      drawer: const AppDrawer(),
    );
  }
}
