import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/cubit/product/product_state.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/services/get_all_product_service.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(ProductsInitial());

  final List<ProductModel> _allProducts = [];   // ✅ الأصلية (من الـ API)
  final List<ProductModel> _products = [];      // ✅ المعروضة بعد الفلترة

  List<ProductModel> get products => _products;

  Future<void> fetchProducts() async {
    emit(ProductLoading());
    try {
      final products = await GetAllProductService().fetchAllProducts();
      _allProducts
        ..clear()
        ..addAll(products);

      _products
        ..clear()
        ..addAll(products);

      emit(ProductsLoaded(List.from(_products)));
    } catch (e) {
      // ✅ بدل ما نرمي Exception للـ UI، بنبعت Error State بالرسالة
      emit(ProductsError("Failed to load products. Please check your connection."));
    }
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      _products
        ..clear()
        ..addAll(_allProducts);
    } else {
      _products
        ..clear()
        ..addAll(
          _allProducts.where((p) {
            final lowerQuery = query.toLowerCase();
            return p.title.toLowerCase().contains(lowerQuery) ||
                p.description.toLowerCase().contains(lowerQuery) ||
                p.price.toString().contains(lowerQuery); // ✅ بحث بالسعر كمان
          }),
        );
    }
    emit(ProductsLoaded(List.from(_products)));
  }

  void setProducts(List<ProductModel> products) {
    _allProducts
      ..clear()
      ..addAll(products);

    _products
      ..clear()
      ..addAll(products);

    emit(ProductsLoaded(List.from(_products)));
  }

  void updateProduct(ProductModel updatedProduct) {
    final index = _allProducts.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      _allProducts[index] = updatedProduct;
    }

    final filteredIndex = _products.indexWhere((p) => p.id == updatedProduct.id);
    if (filteredIndex != -1) {
      _products[filteredIndex] = updatedProduct;
    }

    emit(ProductsLoaded(List.from(_products)));
  }
}
