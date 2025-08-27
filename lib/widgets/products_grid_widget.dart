import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/cubit/product/product_cubit.dart';
import 'package:store_app/cubit/product/product_state.dart';
import 'package:store_app/widgets/custom_card_widget.dart';

class ProductsGridWidget extends StatelessWidget {
  const ProductsGridWidget({
    super.key,
    required this.selectedCategory,
  });

  final String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          if (state is ProductLoading || state is ProductsInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message, // الرسالة اللي جايه من الكيوبت
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProductsCubit>().fetchProducts();
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          } else if (state is ProductsLoaded) {
            final products = state.products;
            // فلترة بالـ category
            final filteredProducts =
                selectedCategory == null
                    ? products
                    : products
                        .where((p) => p.category == selectedCategory)
                        .toList();
    
            if (filteredProducts.isEmpty) {
              return const Center(child: Text("No products found"));
            }
    
            return GridView.builder(
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.7,
                  ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                return CustomCardWidget(
                  product: filteredProducts[index],
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
