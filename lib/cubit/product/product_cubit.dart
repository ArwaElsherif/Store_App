import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/cubit/product/product_state.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/services/get_all_product_service.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(ProductsInitial());

  final List<ProductModel> _products = [];

  List<ProductModel> get products => _products;

  Future<void> fetchProducts() async {
    try {
      final products = await GetAllProductService().fetchAllProducts();
      _products.clear();
      _products.addAll(products);
      emit(ProductsLoaded(List.from(_products))); // ✅ emit state properly
    } catch (e) {
      emit(ProductsError(e.toString())); // ✅ Error state
    }
  }

  // تخزين كل المنتجات بعد ما تجيبيها من API
  void setProducts(List<ProductModel> products) {
    _products.clear();
    _products.addAll(products);
    emit(ProductsLoaded(List.from(_products)));
  }

  // تحديث منتج معين بعد ما يتعدل
  void updateProduct(ProductModel updatedProduct) {
    final index = _products.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      _products[index] = updatedProduct;
      emit(ProductsLoaded(List.from(_products)));
    }
  }
}
