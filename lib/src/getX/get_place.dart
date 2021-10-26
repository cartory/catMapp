import 'package:get/get.dart';

import 'package:catmapp/src/globals.dart';

class GetPlace extends GetxController {
  final _selectedIndex = 0.obs;
  final _places = <Place>[].obs;

  final _isLoading = true.obs;
  final _isLoadingChildren = true.obs;

  List<Place> get places => _places;

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
    refresh();
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
    if (refresh) places.clear();
    final newPlaces = await PlaceApi.findAll(page);
    places.addAllIf(newPlaces.isNotEmpty, newPlaces);
  }

  Future<void> findOne(int id, int index) async {
    final findPlace = await PlaceApi.findOne(id);

    if (findPlace != null) {
      places[index] = findPlace;
    }
  }
}
