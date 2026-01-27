import 'package:flutter/material.dart';
import 'package:toko_online/widgets/bottom_nav.dart';

class BarangView extends StatefulWidget {
  const BarangView({super.key});

  @override
  State<BarangView> createState() => _BarangViewState();
}

class _BarangViewState extends State<BarangView> {
  final Color primaryBlue = const Color(0xFF4C7DAF);
  final Color accentBlue = const Color(0xFF3A6EA5);
  final Color softBlue = const Color(0xFFEAF2FB);

  final List<Map<String, dynamic>> stokBarang = [
    {
      "nama": "Ushanka",
      "stok": 12,
      "gambar": "assets/images/ushanka.jpg",
    },
    {
      "nama": "Sukhoi SU-35",
      "stok": 3,
      "gambar": "assets/images/sukhoi_su35.jpg",
    },
    {
      "nama": "AK-47",
      "stok": 8,
      "gambar": "assets/images/ak47.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBlue,
      appBar: AppBar(
        title: const Text("Stok Barang"),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: stokBarang.length,
          itemBuilder: (context, index) {
            final item = stokBarang[index];
            return Card(
              elevation: 5,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    item["gambar"],
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  item["nama"],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryBlue,
                  ),
                ),
                subtitle: Text(
                  "Stok tersedia: ${item["stok"]}",
                  style: TextStyle(
                    color: accentBlue,
                  ),
                ),
                trailing: Icon(
                  Icons.inventory_2,
                  color: item["stok"] > 0 ? Colors.green : Colors.red,
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNav(1),
    );
  }
}
