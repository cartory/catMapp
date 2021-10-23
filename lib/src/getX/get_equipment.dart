import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:catmapp/src/globals.dart';

class GetEquipment extends GetxController {
  final _place = Place().obs;
  final _equipments = <Equipment>[].obs;

  final _isLoading = true.obs;
  final _isNextPage = false.obs;

  int _page = 0;

  Place get place => _place.value;
  bool get isLoading => _isLoading.value;
  bool get isNextPage => _isNextPage.value;
  List<Equipment> get equipments => _equipments;

  final ScrollController scrollController = ScrollController();

  void setPlace(Place? newPlace) {
    _place.value = newPlace ?? Place();
    refresh();
  }

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
        _page++;
        _isNextPage.value = true;
        findAll().whenComplete(() => _isNextPage.value = false);
      }
    });
  }

  @override
  void refresh() {
    super.refresh();
    _page = 0;
    _isLoading.value = true;
    findAll(refresh: true).whenComplete(() => _isLoading.value = false);
  }

  @override
  void onClose() {
    _place.close();
    _isLoading.close();
    _equipments.close();

    super.onClose();
  }

  Future<void> findAll({int limit = 20, bool refresh = false}) async {
    try {
      String url = '$API_URL/equipments?page=$_page&limit=$limit';

      if (place.id != null) {
        url += '&placeId=${place.id}';
      }

      final res = await http.get(Uri.parse(url));

      final data = json.decode(res.body);
      if (res.statusCode == 500) throw Exception(data['message']);

      if (refresh) equipments.clear();

      final newEquipments = data.map<Equipment>((e) => Equipment.fromJson(e));
      equipments.addAllIf(newEquipments.isNotEmpty, newEquipments);
    } catch (e) {
      print(e);
    }
  }
}
