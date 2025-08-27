import 'package:flutter/material.dart';
import 'package:store_app/services/get_all_categories_service.dart';

class CategoryListWidget extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelected;

  const CategoryListWidget({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: FutureBuilder<List<dynamic>>(
        future: GetAllCategoriesService().getAllCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Failed to load categories",
                    style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () {
                      // 🔄 إعادة بناء FutureBuilder
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            final categories = [
              "All",
              ...snapshot.data!.map((e) => e.toString()),
            ];
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = (category == "All" && selectedCategory == null) ||
                    (category == selectedCategory);

                return GestureDetector(
                  onTap: () {
                    onCategorySelected(category == "All" ? null : category);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
    );
  }
}
