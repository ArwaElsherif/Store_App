import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/cubit/cart/cart_cubit.dart';

class ShoppingCartScreen extends StatelessWidget {
  const ShoppingCartScreen({super.key});
  static String id = 'shopping_cart_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Cart")),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartUpdated) {
            if (state.products.isEmpty) {
              return Center(
                child: Text(
                  "Cart is Empty 🛒",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return ListTile(
                  leading: Image.network(product.image, width: 50),
                  title: Text(product.title),
                  subtitle: Text("\$${product.price}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () {
                      context.read<CartCubit>().removeFromCart(product);
                    },
                  ),
                );
              },
            );
          }
          return const Center(child: Text("Cart is Empty 🛒"));
        },
      ),
    );
  }
}
