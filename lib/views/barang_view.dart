import 'package:flutter/material.dart';
import 'package:toko_online/models/barang_model.dart';
import 'package:toko_online/models/response_data_list.dart';
import 'package:toko_online/services/barang_service.dart';
import 'package:toko_online/views/dashboard.dart';

class BarangView extends StatefulWidget {
  const BarangView({super.key});

  @override
  State<BarangView> createState() => _BarangViewState();
}

class _BarangViewState extends State<BarangView> {
  BarangService barangService = BarangService();
  List<BarangModel>? listBarang;

  @override
  void initState() {
    super.initState();
    getBarang();
  }

  getBarang() async {
    ResponseDataList response =
        await barangService.getBarang();

    if (response.status == true) {
      setState(() {
        listBarang =
            response.data as List<BarangModel>;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Katalog Barang"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const DashboardView(),
              ),
            );
          },
        ),
      ),
      body: listBarang == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: listBarang!.length,
              itemBuilder: (context, index) {
                final item = listBarang![index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  child: ListTile(
                    leading: Image.network(
                      item.image ?? "",
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      item.nama_barang ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Rp ${item.harga?.toStringAsFixed(0)}",
                        ),
                        Text(
                          "Stok: ${item.stok}",
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}