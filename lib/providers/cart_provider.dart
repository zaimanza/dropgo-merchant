import 'package:dropgo/models/address_model.dart';
import 'package:dropgo/models/item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

final cartProvider = ChangeNotifierProvider((ref) => CartProvider());
final CartProvider cartProviderVar = CartProvider();

class CartProvider extends ChangeNotifier {
  late AddressModel address = AddressModel("", "", "", "", "", 0, "");
  late List<ItemModel> items = [];

  setPickupAddress(address) {
    this.address = address;
    notifyListeners();
  }

  addItem(item) {
    items.add(item);
    notifyListeners();
  }

  updateItem(item,index) {
    items[index]=item;
    notifyListeners();
  }

  removeItem(cartId) {
    items.removeWhere((item) => item.cartId == cartId);
    notifyListeners();
  }

  clearCart() {
    address = AddressModel("", "", "", "", "", 0, "");
    items = [];
    print("clearCart");
    print(items.toString());
    notifyListeners();
  }
}
