// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/cubit/product/product_cubit.dart';
import 'package:store_app/screens/search_screen.dart';
import 'package:store_app/widgets/category_list_widget.dart';
import 'package:store_app/widgets/home_app_bar_widget.dart';
import 'package:store_app/widgets/products_grid_widget.dart';

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
      appBar: HomeAppBarWidget(),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 46),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🟢 Categories list
            CategoryListWidget(
              selectedCategory: selectedCategory,
              onCategorySelected: (category) {
                setState(() {
                  selectedCategory = category;
                });
              },
            ),
            const SizedBox(height: 20),
            // 🟢 Products grid
            ProductsGridWidget(selectedCategory: selectedCategory),
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
