// ignore_for_file: invalid_use_of_protected_member

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:catmapp/src/globals.dart' show Place, API_URL;

class GetPlace extends GetxController {
  final _selectedIndex = 0.obs;
  final _places = <Place>[].obs;

  final _isLoading = true.obs;
  final _isLoadingChildren = true.obs;

  List<Place> get places => _places.value;

  int get selectedIndex => _selectedIndex.value;
  Place get selectedPlace => places[selectedIndex];

  bool get isLoading => _isLoading.value;
  bool get isLoadingChildren => _isLoadingChildren.value;

  void setIndex(int index, int placeId) {
    if (selectedIndex != index) {
      _selectedIndex.value = index;
      _isLoadingChildren.value = true;
      findOne(placeId, index).whenComplete(() {
        _isLoadingChildren.value = false;
      });
    }
  }

  @override
  void onInit() {
    super.onInit();
    findAll(refresh: true).whenComplete(() {
      _isLoading.value = false;
      _isLoadingChildren.value = false;
    });
  }

  @override
  void refresh() {
    _isLoading.value = true;
    _isLoadingChildren.value = true;

    findAll(refresh: true).whenComplete(() {
      _isLoading.value = false;
      _selectedIndex.value = 0;
      _isLoadingChildren.value = false;
    });

    super.refresh();
  }

  @override
  void onClose() {
    _places.close();
    _isLoading.close();
    _selectedIndex.close();
    _isLoadingChildren.close();
    super.onClose();
  }

  void seeMorePlaces(int index) {
    _isLoading.value = true;
    _isLoadingChildren.value = true;

    _places.value = places[selectedIndex].places ?? [];

    findOne(places[index].id!.toInt(), index).whenComplete(() {
      _selectedIndex.value = index;

      _isLoading.value = false;
      _isLoadingChildren.value = false;
    });
  }

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
}
