// ignore_for_file: avoid_print

import 'package:store_app/helper/api_helper.dart';
import 'package:store_app/models/product_model.dart';
class UpdateProductService {
  Future<ProductModel> updateProduct({
    required int id,
    required String title,
    required double price,
    required String description,
    required String image,
    required String category,
  }) async {
    print('product id = $id');
    final response = await ApiHelper().put(
      url: 'https://fakestoreapi.com/products/$id',
      body: {
        'title': title,
        'price': price,
        'description': description,
        'image': image,
        'category': category,
      },
      token: null,
    );

    return ProductModel.fromJson(response);
  }
}
