// ignore_for_file: avoid_print, invalid_use_of_protected_member
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:catmapp/src/globals.dart' show Equipment, API_URL;

class GetEquipment extends GetxController {
  final _equipments = <Equipment>[].obs;
  List<Equipment> get equipments => _equipments.value;

  Future<void> findAll({int page = 0, int? placeId, bool refresh = false}) async {
    try {
      final res = await http.get(Uri.parse('$API_URL/equipments?page=$page&placeId=$placeId'));

      final data = json.decode(res.body);
      if (res.statusCode == 500) throw Exception(data['message']);

      if (refresh) equipments.clear();
      equipments.addAll(data.map<Equipment>((e) => Equipment.fromJson(e)));
    } catch (e) {
      print(e);
    }
  }
}
