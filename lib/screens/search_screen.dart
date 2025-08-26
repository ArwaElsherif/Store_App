import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/cubit/product/product_cubit.dart';
import 'package:store_app/widgets/custom_card_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  static String id = 'search_screen';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = "";

  @override
  Widget build(BuildContext context) {
    final allProducts = context.watch<ProductsCubit>().products;

    // فلترة على حسب title  / price فقط
    final searchResults =
        query.isEmpty
            ? []
            : allProducts.where((p) {
              final titleMatch = p.title.toLowerCase().contains(
                query.toLowerCase(),
              );
              // final descMatch =
              //     p.description.toLowerCase().contains(query.toLowerCase());
              final priceMatch = p.price.toString().toLowerCase().contains(
                query.toLowerCase(),
              );
              return titleMatch || priceMatch;
            }).toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Search by title or price...",
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              query = value;
            });
          },
        ),
      ),
      body:
          query.isEmpty
              ? const Center(
                child: Text(
                  "Type something to search...",
                  style: TextStyle(fontSize: 22),
                ),
              )
              : searchResults.isEmpty
              ? const Center(
                child: Text(
                  "No products found",
                  style: TextStyle(fontSize: 32),
                ),
              )
              : GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return CustomCardWidget(product: searchResults[index]);
                },
              ),
    );
  }
}
