import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:store_app/cubit/cart/cart_cubit.dart';
import 'package:store_app/cubit/product/product_cubit.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/services/update_product_service.dart';
import 'package:store_app/widgets/custom_button.dart';
import 'package:store_app/widgets/custom_text_field.dart';

class UpdateProductScreen extends StatefulWidget {
  final ProductModel product;

  const UpdateProductScreen({super.key, required this.product});

  static String id = 'update_product_screen';

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  String? productName, description, image, price;
  bool isLoading = false;

  late TextEditingController titleController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  late TextEditingController imageController;
  late String category;

  @override
  void initState() {
    super.initState();
    // نملأ الكونترولرز بالبيانات القديمة
    titleController = TextEditingController(text: widget.product.title);
    priceController = TextEditingController(text: widget.product.price.toString());
    descriptionController = TextEditingController(text: widget.product.description);
    imageController = TextEditingController(text: widget.product.image);
    category = widget.product.category;
  }

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args == null || args is! ProductModel) {
      return const Center(child: Text('No product found'));
    }
    final product = args;

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Update Product',
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 50),
                CustomTextField(
                  hintText: 'product name',
                  controller: titleController,
                  onChanged: (data) {
                    productName = data;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hintText: 'description',
                  controller: descriptionController,
                  onChanged: (data) {
                    description = data;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hintText: 'price',
                  controller: priceController,
                  onChanged: (data) {
                    price = data;
                  },
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 70),
                CustomButton(
                  text: 'Update',
                  onTap: () async {
                    isLoading = true;
                    setState(() {});
                    try {
                      final updatedProduct = await updateProduct(product);

                      // Update products list
                      context.read<ProductsCubit>().updateProduct(updatedProduct);

                      // Update cart if needed
                      context.read<CartCubit>().updateProductInCart(updatedProduct);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Product updated successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );

                      Navigator.pop(context, updatedProduct); // ✅ رجع المنتج الجديد
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                    isLoading = false;
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<ProductModel> updateProduct(ProductModel product) async {
    double parsedPrice =
        double.tryParse(price ?? product.price.toString()) ?? product.price;

    final updated = await UpdateProductService().updateProduct(
      id: product.id,
      title: productName ?? product.title,
      price: parsedPrice,
      description: description ?? product.description,
      image: image ?? product.image,
      category: product.category,
    );

    return updated; // ✅ نرجع المنتج الجديد
  }
}
