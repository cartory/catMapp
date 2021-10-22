// ignore_for_file: invalid_use_of_protected_member, avoid_print

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:catmapp/src/globals.dart';

class GetEquipment extends GetxController {
  final _place = Place().obs;
  final _equipments = <Equipment>[].obs;

  final _isLoading = true.obs;

  Place get place => _place.value;
  bool get isLoading => _isLoading.value;
  List<Equipment> get equipments => _equipments.value;

  void setPlace(Place? newPlace) {
    _place.value = newPlace ?? Place();
    refresh();
  }

  @override
  void refresh() {
    super.refresh();
    _isLoading.value = true;
    findAll(refresh: true).whenComplete(() {
      _isLoading.value = false;
    });
  }

  @override
  void onClose() {
    _place.close();
    _isLoading.close();
    _equipments.close();

    super.onClose();
  }

  Future<void> findAll({int page = 0, int limit = 15, bool refresh = false}) async {
    try {
      String url = '$API_URL/equipments?page=$page&limit=$limit';

      if (place.id != null) {
        url += '&placeId=${place.id}';
      }

      print(url);

      final res = await http.get(Uri.parse(url));

      final data = json.decode(res.body);
      if (res.statusCode == 500) throw Exception(data['message']);

      if (refresh) equipments.clear();

      equipments.addAll(data.map<Equipment>((e) => Equipment.fromJson(e)));
    } catch (e) {
      print(e);
    }
  }
}
