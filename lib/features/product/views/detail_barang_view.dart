import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

import 'package:toko_online/features/product/models/barang_model.dart';
import 'package:toko_online/features/cart/models/cart.dart';
import 'package:toko_online/features/cart/providers/cartProvider.dart';
import 'package:toko_online/core/widgets/alert.dart';
import 'package:toko_online/core/services/dbhelper.dart';
import 'package:toko_online/features/order/services/transaksi_service.dart';

class DetailBarangView extends StatefulWidget {
  final BarangModel item;

  const DetailBarangView({super.key, required this.item});

  @override
  State<DetailBarangView> createState() => _DetailBarangViewState();
}

class _DetailBarangViewState extends State<DetailBarangView> {
  final Color primaryBlue = const Color(0xFF4C7DAF);
  final Color accentBlue = const Color(0xFF3A6EA5);
  final Color softBlue = const Color(0xFFEAF2FB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBlue,
      appBar: AppBar(
        title: Text(widget.item.nama_barang ?? "Detail Produk"),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                return badges.Badge(
                  showBadge: cartProvider.counter > 0,
                  badgeContent: Text(
                    '${cartProvider.counter}',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () => Navigator.pushNamed(context, '/cart'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// GAMBAR PRODUK BESAR
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5)),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: Image.network(
                  widget.item.image ?? "",
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
                      SizedBox(height: 8),
                      Text("Gambar tidak tersedia", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// NAMA BARANG
                  Text(
                    widget.item.nama_barang ?? "",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 8),

                  /// HARGA & STOK
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Rp ${widget.item.harga}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "Stok: ${widget.item.stok}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  /// DESKRIPSI
                  Text(
                    "Deskripsi Produk",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Ini adalah deksripsi singkat dari produk ${widget.item.nama_barang}. Produk berkualitas tinggi yang cocok untuk kebutuhan Anda.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      /// BOTTOM ACTION BUTTONS
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            /// KERANJANG
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: primaryBlue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  _addToCart(context);
                },
                icon: Icon(Icons.add_shopping_cart, color: primaryBlue),
                label: Text(
                  "Keranjang",
                  style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 16),

            /// PESAN LANGSUNG
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  _showPesanLangsungModal(context);
                },
                icon: const Icon(Icons.shopping_bag, color: Colors.white),
                label: const Text(
                  "Beli Langsung",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart(BuildContext context) async {
    var cartProvider = Provider.of<CartProvider>(context, listen: false);
    DBHelper dbHelper = DBHelper();
    
    await dbHelper.insert(
      Cart(
        id: widget.item.id,
        barang_id: widget.item.id.toString(),
        nama_barang: widget.item.nama_barang,
        harga: widget.item.harga?.toInt(),
        quantity: 1,
        image: widget.item.image,
      ),
    );

    cartProvider.getCounter();

    AlertMessage().showAlert(context, "Berhasil ditambahkan ke keranjang", true);
  }

  void _showPesanLangsungModal(BuildContext context) {
    int qty = 1;
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            int totalHarga = (widget.item.harga?.toInt() ?? 0) * qty;

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Atur Jumlah Beli",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Jumlah",
                        style: TextStyle(fontSize: 16),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (qty > 1) {
                                setModalState(() => qty--);
                              }
                            },
                            icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                          ),
                          Text(
                            "$qty",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (qty < (widget.item.stok ?? 0)) {
                                setModalState(() => qty++);
                              } else {
                                AlertMessage().showAlert(context, "Mencapai batas stok", false);
                              }
                            },
                            icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total Harga",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      Text(
                        "Rp $totalHarga",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        var service = TransaksiService();
                        
                        Cart dummyCartItem = Cart(
                          id: widget.item.id,
                          barang_id: widget.item.id.toString(),
                          nama_barang: widget.item.nama_barang,
                          harga: widget.item.harga?.toInt(),
                          quantity: qty,
                          image: widget.item.image,
                        );

                        var result = await service.checkout([dummyCartItem], totalHarga);

                        if (result.status == true) {
                          Navigator.pop(context);
                          AlertMessage().showAlert(context, "Pesanan Berhasil", true);
                          Navigator.pushReplacementNamed(context, '/pesan');
                        } else {
                          Navigator.pop(context);
                          AlertMessage().showAlert(context, result.message, false);
                        }
                      },
                      child: const Text(
                        "Pesan Sekarang",
                        style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
