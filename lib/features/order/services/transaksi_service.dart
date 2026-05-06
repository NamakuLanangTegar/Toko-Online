import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:toko_online/core/services/url.dart' as url;
import 'package:toko_online/features/auth/models/user_login.dart';
import 'package:toko_online/features/order/models/transaksi_model.dart';
import 'package:toko_online/core/models/response_data_map.dart';
import 'package:toko_online/features/cart/models/cart.dart';

class TransaksiService {
  UserLogin userLogin = UserLogin();

  /// ================= GET HISTORY TRANSAKSI =================
  /// API: GET /user/history_trans
  /// Response: { "data": [ { "id_transaksi", "nama_user", "tgl_transaksi", "detail": [...] } ] }
  Future<List<TransaksiModel>> getHistoryTransaksi() async {
    var user = await userLogin.getUserLogin();
    if (user.status == false) return [];

    try {
      var response = await http.get(
        Uri.parse('${url.BaseUrl}/user/history_trans'),
        headers: {
          'Authorization': 'Bearer ${user.token}',
          'Accept': 'application/json',
        },
      );

      print('History API status: ${response.statusCode}');
      print('History API body: ${response.body}');

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == true && data['data'] != null) {
          List<dynamic> list = data['data'];
          var result = list.map((e) => TransaksiModel.fromJson(e as Map<String, dynamic>)).toList();
          
          // Sort terbaru (berdasarkan idTransaksi descending atau tglTransaksi)
          result.sort((a, b) => (b.idTransaksi ?? 0).compareTo(a.idTransaksi ?? 0));
          
          return result;
        }
      }
    } catch (e) {
      print('Error getHistoryTransaksi: $e');
    }
    return [];
  }

  /// ================= CHECKOUT (POST TRANSAKSI) =================
  /// API: POST /user/transaksi
  /// Body: { "pesan": [ { "barang_id": 155, "qty": 2 }, ... ] }
  Future<ResponseDataMap> checkout(List<Cart> items, int totalHarga) async {
    var user = await userLogin.getUserLogin();
    if (user.status == false) {
      return ResponseDataMap(status: false, message: 'Silakan login terlebih dahulu');
    }

    try {
      List<Map<String, dynamic>> pesanList = items.map((e) => {
        'barang_id': int.tryParse(e.barang_id ?? '0') ?? 0,
        'qty': e.quantity ?? 1,
      }).toList();

      var body = json.encode({'pesan': pesanList});

      var response = await http.post(
        Uri.parse('${url.BaseUrl}/user/transaksi'),
        headers: {
          'Authorization': 'Bearer ${user.token}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: body,
      );

      var responseData = json.decode(response.body);
      return ResponseDataMap(
        status: responseData['status'] ?? false,
        message: responseData['message'] ?? 'Unknown error',
        data: responseData['data'],
      );
    } catch (e) {
      print('Error checkout: $e');
      return ResponseDataMap(status: false, message: 'Terjadi kesalahan koneksi: $e');
    }
  }
}
