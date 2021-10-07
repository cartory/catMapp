// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../globals.dart' show Place, API_URL;

class PlaceApi {
  static Future find(int? id) async {
    try {
      final res = await http.get(Uri.parse('$API_URL/places/${id ?? ''}'));

      if (id == null) {
        final places = jsonDecode(res.body);
        return List<Place>.from(places.map((place) => Place.fromJson(place)));
      }

      return Place.fromRawJson(res.body);
    } catch (err) {
      print(err);
    }
    return null;
  }

  static Future<bool> save(Place place) async {
    try {
      final res = await http.post(Uri.parse('$API_URL/places/${place.id ?? ''}'));
      final data = jsonDecode(res.body);

      if (res.statusCode == 500) throw Exception(data['message']);

      return true;
    } catch (err) {
      print(err);
    }
    return false;
  }
}
