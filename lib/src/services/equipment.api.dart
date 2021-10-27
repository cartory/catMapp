import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:catmapp/src/globals.dart';

class EquipmentApi {
  static Future<Equipment?> findOne(int id) async {
    try {
      final res = await http.get(Uri.parse('$API_URL/equipments/$id'));
      final data = json.decode(res.body);

      if (res.statusCode == 500) throw Exception(data['message']);

      return Equipment.fromJson(data);
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  static Future<List<Equipment>> findAll({int? page = 0, int? limit = 20, int? placeId, String? query}) async {
    try {
      String url = '$API_URL/equipments?page=$page&limit=$limit';

      if (query != null) url += '&query=$query';
      if (placeId != null) url += '&placeId=$placeId';

      final res = await http.get(Uri.parse(url));
      final data = json.decode(res.body);

      if (res.statusCode == 500) throw Exception(data['message']);

      return List.from(data.map((e) => Equipment.fromJson(e)));
    } catch (e) {
      log(e.toString());
    }

    return [];
  }
}
