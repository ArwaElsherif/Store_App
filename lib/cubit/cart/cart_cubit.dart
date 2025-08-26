import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/services/local_storage_service.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial()){
    loadCart();
  }

  final List<ProductModel> _cartItems = [];

  List<ProductModel> get cartItems => _cartItems;
void loadCart() {
  final savedData = LocalStorageService.getData("cart") as List<String>?;
  if (savedData != null) {
    _cartItems.clear();
    _cartItems.addAll(
      savedData.map((e) => ProductModel.fromJson(jsonDecode(e))),
    );
    emit(CartUpdated(List.from(_cartItems)));
  }
}

void _saveCart() {
  final data = _cartItems.map((e) => jsonEncode(e.toJson())).toList();
  LocalStorageService.setData("cart", data);
}

void addToCart(ProductModel product) {
  if (!_cartItems.contains(product)) {
    _cartItems.add(product);
    _saveCart();
    emit(CartUpdated(List.from(_cartItems)));
  }
}

void removeFromCart(ProductModel product) {
  _cartItems.remove(product);
  _saveCart();
  emit(CartUpdated(List.from(_cartItems)));
}

void updateProductInCart(ProductModel updatedProduct) {
  final index = _cartItems.indexWhere((p) => p.id == updatedProduct.id);
  if (index != -1) {
    _cartItems[index] = updatedProduct;
    emit(CartUpdated(List.from(_cartItems)));
  }
}

}
