// ignore_for_file: avoid_print, invalid_use_of_protected_member
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../globals.dart' show Place, API_URL;

class GetPlace extends GetxController {
  final _places = <Place>[].obs;
  List<Place> get places => _places.value;

  Future<void> findAll({int page = 0, bool refresh = false}) async {
    try {
      final res = await http.get(Uri.parse('$API_URL/places?page=$page'));

      final data = json.decode(res.body);
      if (res.statusCode == 500) throw Exception(data['message']);

      if (refresh) places.clear();
      places.addAll(data.map<Place>((place) => Place.fromJson(place)));
    } catch (err) {
      print(err);
    }
  }

  Future<void> findOne(int id, int index) async {
    try {
      final res = await http.get(Uri.parse('$API_URL/places/$id'));

      final data = json.decode(res.body);
      if (res.statusCode == 500) throw Exception(data['message']);

      places[index] = Place.fromJson(data);
    } catch (err) {
      print(err);
    }
  }

  Future<void> replaceAll(List<Place> subPlaces, int index) async {
    _places.value = subPlaces;
    await findOne(subPlaces[index].id!.toInt(), index);
  }
}
