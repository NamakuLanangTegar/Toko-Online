class TransaksiModel {
  final int? idTransaksi;
  final String? namaUser;
  final String? tglTransaksi;
  final List<TransaksiDetailModel> detail;

  TransaksiModel({
    this.idTransaksi,
    this.namaUser,
    this.tglTransaksi,
    required this.detail,
  });

  factory TransaksiModel.fromJson(Map<String, dynamic> json) {
    var detailList = <TransaksiDetailModel>[];
    if (json['detail'] != null) {
      detailList = (json['detail'] as List)
          .map((e) => TransaksiDetailModel.fromJson(e))
          .toList();
    }

    return TransaksiModel(
      idTransaksi: json['id_transaksi'],
      namaUser: json['nama_user'],
      tglTransaksi: json['tgl_transaksi'],
      detail: detailList,
    );
  }
}

class TransaksiDetailModel {
  final int? idDetailTransaksi;
  final int? barangId;
  final String namaBarang;
  final int quantity;
  final int hargaBeli;

  TransaksiDetailModel({
    this.idDetailTransaksi,
    this.barangId,
    required this.namaBarang,
    required this.quantity,
    required this.hargaBeli,
  });

  factory TransaksiDetailModel.fromJson(Map<String, dynamic> json) {
    return TransaksiDetailModel(
      idDetailTransaksi: json['id_detail_transaksi'],
      barangId: json['barang_id'],
      namaBarang: json['nama_barang'] ?? '',
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      hargaBeli: int.tryParse(json['harga_beli']?.toString() ?? '0') ?? 0,
    );
  }
}
