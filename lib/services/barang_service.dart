import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:toko_online/models/barang_model.dart';
import 'package:toko_online/models/response_data_list.dart';
import 'package:toko_online/models/user_login.dart';
import 'package:toko_online/services/url.dart' as url;

class BarangService {
  Future getBarang() async {
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();

    if (user.status == false) {
      return ResponseDataList(
        status: false,
        message: "Anda belum login / token invalid",
      );
    }

    var uri = Uri.parse("${url.BaseUrl}/admin/getbarang");

    Map<String, String> headers = {
      "Authorization": "Bearer ${user.token}",
    };

    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      if (data["status"] == true) {
        List<BarangModel> barang =
            (data["data"] as List)
                .map((e) => BarangModel.fromJson(e))
                .toList();

        return ResponseDataList(
          status: true,
          message: "Success load data",
          data: barang,
        );
      } else {
        return ResponseDataList(
          status: false,
          message: "Failed load data",
        );
      }
    } else {
      return ResponseDataList(
        status: false,
        message:
            "Error ${response.statusCode}",
      );
    }
  }
}