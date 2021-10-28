import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:catmapp/src/globals.dart';

class GetEquipment extends GetxController {
  final _place = Place().obs;
  final _equipments = <Equipment>[].obs;

  final _isLoading = true.obs;
  final _isNextPage = false.obs;
  final _isModeSelected = false.obs;

  int _page = 0;

  Place get place => _place.value;
  bool get isLoading => _isLoading.value;
  bool get isNextPage => _isNextPage.value;
  bool get isModeSelected => _isModeSelected.value;

  List<Equipment> get equipments => _equipments;

  final ScrollController scrollController = ScrollController();

  void setPlace(Place? newPlace) {
    _place.value = newPlace ?? Place();
    refresh();
  }

  void clearSelect() {
    _equipments.value = _equipments.map((e) => e..isSelected = false).toList();
  }

  set isModeSelected(bool value) {
    _isLoading.value = true;
    _isModeSelected.value = value;
    _isLoading.value = false;
  }

  void setChecked(int index, bool value) {
    _equipments[index] = _equipments[index]..isSelected = value;
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
    _isModeSelected.value = false;
    findAll(refresh: true).whenComplete(() => _isLoading.value = false);
  }

  @override
  void onClose() {
    _place.close();
    _isLoading.close();
    _equipments.close();

    super.onClose();
  }

  Future<void> findAll({int limit = 20, bool refresh = false, String? query}) async {
    if (refresh) equipments.clear();
    final newEquipments = await EquipmentApi.findAll(
      page: _page,
      limit: limit,
      query: query,
      placeId: place.id,
    );
    equipments.addAllIf(newEquipments.isNotEmpty, newEquipments);
  }
}
