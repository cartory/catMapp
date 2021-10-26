import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:catmapp/src/globals.dart';

class PlaceApi {
  static Future<Place?> findOne(int id) async {
    try {
      final res = await http.get(Uri.parse('$API_URL/places/$id'));

      final data = json.decode(res.body);

      if (res.statusCode == 500) throw Exception(data['message']);

      return Place.fromJson(data);
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  static Future<List<Place>> findAll(int page) async {
    try {
      final res = await http.get(Uri.parse('$API_URL/places?page=$page'));

      final data = json.decode(res.body);

      if (res.statusCode == 500) throw Exception(data['message']);

      return List.from(data.map((p) => Place.fromJson(p)));
    } catch (e) {
      log(e.toString());
    }

    return [];
  }
}
