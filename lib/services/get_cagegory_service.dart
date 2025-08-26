import 'package:store_app/helper/api_helper.dart';
import 'package:store_app/models/product_model.dart';

class GetCagegoryService {
  
  Future<List<ProductModel>> getCategoriesProducts({
    required String categoryName,
  }) async {
   List<dynamic> data = await ApiHelper().get(
      url: 'https://fakestoreapi.com/products/category/$categoryName',
    );
    return data.map((item) => ProductModel.fromJson(item)).toList();

  }

  
}
