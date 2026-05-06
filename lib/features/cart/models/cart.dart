class Cart {
  late final int? id;

  final String? barang_id;
  final String? nama_barang;

  final int? harga;
  int? quantity = 0;
  final String? image;

  Cart({
    required this.id,
    required this.barang_id,
    required this.nama_barang,
    required this.harga,
    required this.quantity,
    required this.image,
  });

  factory Cart.fromMap(Map<dynamic, dynamic> data) {
    return Cart(
      id: data['id'],
      barang_id: data['barang_id'],
      nama_barang: data['nama_barang'],
      harga: data['harga'],
      quantity: data['quantity'],
      image: data['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'barang_id': barang_id,
      'nama_barang': nama_barang,
      'harga': harga,
      'quantity': quantity,
      'image': image,
    };
  }
}
