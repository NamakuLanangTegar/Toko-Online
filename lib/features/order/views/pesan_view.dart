import 'package:flutter/material.dart';
import 'package:toko_online/features/order/models/transaksi_model.dart';
import 'package:toko_online/features/order/services/transaksi_service.dart';
import 'package:toko_online/core/widgets/bottom_nav.dart';

class PesanView extends StatefulWidget {
  const PesanView({super.key});

  @override
  State<PesanView> createState() => _PesanViewState();
}

class _PesanViewState extends State<PesanView> {
  final Color primaryBlue = const Color(0xFF4C7DAF);
  final Color accentBlue = const Color(0xFF3A6EA5);
  final Color softBlue = const Color(0xFFEAF2FB);

  List<TransaksiModel> transaksiList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  void loadHistory() async {
    setState(() => isLoading = true);

    var service = TransaksiService();
    var result = await service.getHistoryTransaksi();

    setState(() {
      transaksiList = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBlue,
      appBar: AppBar(
        title: const Text("History Transaksi"),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Refresh",
            onPressed: () => loadHistory(),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : transaksiList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long, size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        "Belum ada transaksi",
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => loadHistory(),
                        icon: const Icon(Icons.refresh),
                        label: const Text("Refresh"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async => loadHistory(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: transaksiList.length,
                    itemBuilder: (context, index) {
                      var transaksi = transaksiList[index];

                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// HEADER TRANSAKSI
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: primaryBlue,
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.receipt, color: Colors.white70, size: 18),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Order #${transaksi.idTransaksi}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    transaksi.tglTransaksi ?? "-",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// NAMA USER
                            if (transaksi.namaUser != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Row(
                                  children: [
                                    Icon(Icons.person, size: 16, color: primaryBlue),
                                    const SizedBox(width: 6),
                                    Text(
                                      transaksi.namaUser!,
                                      style: TextStyle(color: primaryBlue, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),

                            /// DETAIL ITEM
                            if (transaksi.detail.isEmpty)
                              const Padding(
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  "Tidak ada detail item",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            else
                              ...transaksi.detail.map((item) => Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    child: Row(
                                      children: [
                                        /// ICON BARANG
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            color: Colors.grey[200],
                                            child: Icon(Icons.shopping_bag,
                                                color: primaryBlue, size: 28),
                                          ),
                                        ),
                                        const SizedBox(width: 12),

                                        /// INFO ITEM
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.namaBarang,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: primaryBlue,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "Qty: ${item.quantity}",
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        /// HARGA
                                        Text(
                                          "Rp ${_formatHarga(item.hargaBeli)}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),

                            const Divider(height: 1),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Text(
                                "${transaksi.detail.length} item",
                                style: TextStyle(color: Colors.grey[500], fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

      bottomNavigationBar: BottomNav(2),
    );
  }

  String _formatHarga(int harga) {
    return harga.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
  }
}