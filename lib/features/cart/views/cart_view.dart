import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:toko_online/features/cart/providers/cartProvider.dart';

import 'package:toko_online/core/widgets/alert.dart';
import 'package:toko_online/features/order/services/transaksi_service.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final Color primaryBlue = const Color(0xFF4C7DAF);
  final Color accentBlue = const Color(0xFF3A6EA5);
  final Color softBlue = const Color(0xFFEAF2FB);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CartProvider>(context, listen: false).getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBlue,
      appBar: AppBar(
        title: const Text("Keranjang"),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.cart.isEmpty) {
            return const Center(child: Text("Keranjang Kosong"));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartProvider.cart.length,
                  itemBuilder: (context, index) {
                    var item = cartProvider.cart[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            /// FOTO
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                item.image ?? "",
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                        width: 80, 
                                        height: 80, 
                                        color: Colors.grey[300], 
                                        child: const Icon(Icons.image, size: 40)
                                    ),
                              ),
                            ),
                            const SizedBox(width: 16),

                            /// INFO
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.nama_barang ?? "",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: primaryBlue,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Rp ${item.harga}",
                                    style: TextStyle(
                                      color: accentBlue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// QTY CONTROL
                            Column(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle_outline),
                                      onPressed: () {
                                        cartProvider.deleteQuantity(item.id!);
                                      },
                                      color: Colors.red,
                                    ),
                                    Text(
                                      "${item.quantity}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add_circle_outline),
                                      onPressed: () {
                                        cartProvider.addQuantity(item.id!);
                                      },
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    cartProvider.removeItem(item.id!);
                                    cartProvider.getCounter();
                                  },
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              /// CHECKOUT PANEL
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Total Harga",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          "Rp ${_calculateTotal(cartProvider)}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryBlue,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        var total = _calculateTotal(cartProvider);
                        var service = TransaksiService();
                        var result = await service.checkout(cartProvider.cart, total);

                        if (result.status == true) {
                          AlertMessage().showAlert(context, "Checkout Berhasil", true);
                          // Kosongkan keranjang di SQLite
                          for (var item in cartProvider.cart) {
                            cartProvider.dBHelper.deleteCartItem(item.id!);
                          }
                          cartProvider.cart.clear();
                          cartProvider.getCounter();
                          
                          Navigator.pushReplacementNamed(context, '/pesan');
                        } else {
                          AlertMessage().showAlert(context, result.message, false);
                        }
                      },
                      child: const Text(
                        "Checkout",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  int _calculateTotal(CartProvider provider) {
    int total = 0;
    for (var item in provider.cart) {
      total += (item.harga ?? 0) * (item.quantity ?? 0);
    }
    return total;
  }
}
