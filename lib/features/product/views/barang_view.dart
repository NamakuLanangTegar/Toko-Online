import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

import 'package:toko_online/features/cart/providers/cartProvider.dart';
import 'package:toko_online/features/product/models/barang_model.dart';
import 'package:toko_online/core/models/response_data_list.dart';
import 'package:toko_online/features/auth/models/user_login.dart';

import 'package:toko_online/features/product/services/barang_service.dart';

import 'package:toko_online/features/product/views/tambah_barang_view.dart';
import 'package:toko_online/features/product/views/detail_barang_view.dart';

import 'package:toko_online/core/widgets/alert.dart';
import 'package:toko_online/core/widgets/bottom_nav.dart';

class BarangView extends StatefulWidget {
  /// isEmbedded = true ketika dipanggil di dalam AdminDashboardView (tidak pakai Scaffold)
  final bool isEmbedded;
  const BarangView({super.key, this.isEmbedded = false});

  @override
  State<BarangView> createState() => _BarangViewState();
}

class _BarangViewState extends State<BarangView> {
  BarangService barangService = BarangService();
  UserLogin userLogin = UserLogin();

  List<BarangModel>? listBarang;
  String? role;

  final Color primaryBlue = const Color(0xFF4C7DAF);
  final Color accentBlue = const Color(0xFF3A6EA5);
  final Color softBlue = const Color(0xFFEAF2FB);

  @override
  void initState() {
    super.initState();
    getBarang();
    getUser();
  }

  getUser() async {
    var user = await userLogin.getUserLogin();
    setState(() {
      role = user.role;
    });
  }

  getBarang() async {
    ResponseDataList response = await barangService.getBarang();
    if (response.status == true) {
      setState(() {
        listBarang = response.data as List<BarangModel>;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Jika embedded (di dalam AdminDashboard), tidak pakai Scaffold
    if (widget.isEmbedded) {
      return _buildBody();
    }

    return Scaffold(
      backgroundColor: softBlue,
      appBar: AppBar(
        title: const Text("Katalog Barang"),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: _buildActions(),
      ),
      body: _buildBody(),
      bottomNavigationBar: role == 'admin' ? null : BottomNav(1),
    );
  }

  List<Widget> _buildActions() {
    List<Widget> actions = [];

    // Tombol refresh untuk semua role
    actions.add(IconButton(
      icon: const Icon(Icons.refresh),
      tooltip: "Refresh",
      onPressed: () => getBarang(),
    ));

    // Admin: tombol tambah barang
    if (role == 'admin') {
      actions.add(IconButton(
        icon: const Icon(Icons.add),
        tooltip: "Tambah Barang",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TambahBarangView(title: "Tambah Barang"),
            ),
          ).then((_) => getBarang());
        },
      ));
    }

    // USER: icon keranjang di AppBar
    if (role == 'user') {
      actions.add(
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
                  tooltip: "Keranjang",
                  onPressed: () {
                    Navigator.pushNamed(context, '/cart');
                  },
                ),
              );
            },
          ),
        ),
      );
    }

    return actions;
  }

  Widget _buildBody() {
    if (listBarang == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (listBarang!.isEmpty) {
      return const Center(child: Text("Belum ada barang"));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: listBarang!.length,
      itemBuilder: (context, index) {
        final item = listBarang![index];

        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: role == 'user'
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailBarangView(item: item),
                      ),
                    );
                  }
                : null, // Admin tidak bisa klik ke detail
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),

              /// GAMBAR
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  item.image ?? "",
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 64, height: 64,
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 64, height: 64,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
                ),
              ),

              /// NAMA
              title: Text(
                item.nama_barang ?? "",
                style: TextStyle(fontWeight: FontWeight.bold, color: primaryBlue),
              ),

              /// HARGA & STOK
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Rp ${item.harga?.toStringAsFixed(0)}", style: TextStyle(color: accentBlue)),
                  Text("Stok : ${item.stok}", style: const TextStyle(fontSize: 12)),
                ],
              ),

              /// TRAILING
              trailing: role == "admin"
                  ? PopupMenuButton<String>(
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: "update", child: Text("Update")),
                        const PopupMenuItem(value: "hapus", child: Text("Hapus")),
                      ],
                      onSelected: (String value) async {
                        if (value == "update") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TambahBarangView(title: "Update Barang", item: item),
                            ),
                          ).then((_) => getBarang());
                        }
                        if (value == "hapus") {
                          var result = await AlertMessage().showAlertDialog(context);
                          if (result != null && result['status'] == true) {
                            var res = await barangService.hapusBarang(item.id);
                            AlertMessage().showAlert(context, res.message, res.status == true);
                            if (res.status == true) getBarang();
                          }
                        }
                      },
                    )
                  : const Icon(Icons.chevron_right, color: Colors.grey),
            ),
          ),
        );
      },
    );
  }
}
