import 'package:flutter/material.dart';

import 'package:toko_online/features/cart/models/cart.dart';
import 'package:toko_online/core/services/dbhelper.dart';

class CartProvider extends ChangeNotifier {

  DBHelper dBHelper = DBHelper();

  List<Cart> cart = [];

  int counter = 0;

  /// ================= GET DATA CART =================
  Future<List<Cart>> getData() async {

    cart = await dBHelper.getCartList();

    notifyListeners();

    return cart;
  }

  /// ================= HITUNG TOTAL ITEM =================
  void getCounter() async {

    await getData();

    counter = cart.length;

    notifyListeners();
  }

  /// ================= TAMBAH QTY =================
  void addQuantity(int id) async {

    final index =
        cart.indexWhere((e) => e.id == id);

    cart[index].quantity =
        cart[index].quantity! + 1;

    await dBHelper.updateQuantity(
      cart[index].id,
      cart[index].quantity,
    );

    notifyListeners();
  }

  /// ================= KURANG QTY =================
  void deleteQuantity(int id) async {

    final index =
        cart.indexWhere((e) => e.id == id);

    if (cart[index].quantity! > 1) {

      cart[index].quantity =
          cart[index].quantity! - 1;
    }

    await dBHelper.updateQuantity(
      cart[index].id,
      cart[index].quantity,
    );

    notifyListeners();
  }

  /// ================= HAPUS ITEM =================
  void removeItem(int id) async {

    final index =
        cart.indexWhere((e) => e.id == id);

    cart.removeAt(index);
    
    await dBHelper.deleteCartItem(id);

    notifyListeners();
  }
}