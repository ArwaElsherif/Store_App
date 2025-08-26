import 'package:store_app/helper/api_helper.dart';
import 'package:store_app/models/product_model.dart';

class GetAllProductService {

  // Fetches all products from the API and returns a list of ProductModel.
  Future<List<ProductModel>> fetchAllProducts() async {
    List<dynamic> data = await ApiHelper().get(
      url: 'https://fakestoreapi.com/products',
    );
    return data.map((item) => ProductModel.fromJson(item)).toList();
  }

  
}
