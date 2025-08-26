import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/cubit/cart/cart_cubit.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/screens/update_product_screen.dart';

class CustomCard extends StatefulWidget {
  const CustomCard({super.key, required this.product});
  final ProductModel product;

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  late ProductModel product;
  bool isAdd = false; // ✅ الحالة الافتراضية مش متلون

  @override
  void initState() {
    super.initState();
    product = widget.product;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final updatedProduct = await Navigator.pushNamed(
          context,
          UpdateProductScreen.id,
          arguments: product,
        );
        if (updatedProduct != null && updatedProduct is ProductModel) {
          setState(() {
            product = updatedProduct;
            // ✅ تحديث الكارت بالمنتج الجديد
          });
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 60),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05), // خفيف جدًا
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(5, 0), // يمين
                ),
              ],
            ),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      product.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 55, 54, 54),
                      ),
                    ),
                    Text(
                      product.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 164, 161, 161),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$${product.price}",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isAdd = !isAdd;
                            });

                            if (isAdd) {
                              context.read<CartCubit>().addToCart(
                                widget.product,
                              );
                            } else {
                              context.read<CartCubit>().removeFromCart(
                                widget.product,
                              );
                            }
                          },
                          child: Icon(
                            Icons.add_shopping_cart,
                            color:
                                isAdd
                                    ? Colors.red
                                    : Colors.grey, // ✅ اللون حسب الحالة
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 15,
            top: -10,
            child: Image.network(
              // errorBuilder: (context, error, stackTrace) {
              //   return Image.asset(
              //     width: 100,
              // height: 100,
              //     'assets/placeholder.png',
              //   ); // صورة بديلة
              // },
              product.image,
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
