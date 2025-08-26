// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/cubit/product/product_cubit.dart';
import 'package:store_app/cubit/product/product_state.dart';
import 'package:store_app/cubit/theme/theme_cubit.dart';
import 'package:store_app/screens/search_screen.dart';
import 'package:store_app/screens/shopping_cart_screen.dart';
import 'package:store_app/services/get_all_categories_service.dart';
import 'package:store_app/widgets/custom_card_widget.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});
  static String id = 'home_page_screen';

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductsCubit>().fetchProducts();
  }

  String? selectedCategory;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('New Trend'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, ShoppingCartScreen.id);
            },
            icon: const Icon(Icons.shopping_cart),
          ),
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(
                  state == ThemeMode.light ? Icons.dark_mode : Icons.light_mode,
                ),
                onPressed: () {
                  context.read<ThemeCubit>().toggleTheme();
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 46),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🟢 ده دايمًا ثابت فوق
            SizedBox(
              height: 50,
              child: FutureBuilder<List<dynamic>>(
                future: GetAllCategoriesService().getAllCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final categories = [
                      "All",
                      ...snapshot.data!.map((e) => e.toString()),
                    ];
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder:
                          (context, index) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final isSelected =
                            (category == "All" && selectedCategory == null) ||
                            (category == selectedCategory);

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory =
                                  category == "All" ? null : category;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? Colors.black
                                      : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                category,
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text("No categories found"));
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            // 🟢 ده اللي بي Scroll
            Expanded(
              child: BlocBuilder<ProductsCubit, ProductsState>(
                builder: (context, state) {
                  if (state is ProductsInitial) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProductsError) {
                    return Center(child: Text("Error: ${state.message}"));
                  } else if (state is ProductsLoaded) {
                    final products = state.products;

                    // فلترة بالـ category
                    final filteredProducts =
                        selectedCategory == null
                            ? products
                            : products
                                .where((p) => p.category == selectedCategory)
                                .toList();

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
                        return CustomCardWidget(product: filteredProducts[index]);
                      },
                    );
                  } else {
                    return const Center(child: Text("No products found"));
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
         onPressed: () {
              Navigator.pushNamed(context, SearchScreen.id);
            },
      ),
    );
  }
}
