import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:catmapp/src/globals.dart';
import 'package:catmapp/src/utils/debouncer.dart';

class EquipmentApi {
  late final Debouncer<String> _debouncer;
  final _equipmentController = StreamController<List<Equipment>>.broadcast();

  Stream<List<Equipment>> get dataStream => _equipmentController.stream;
  Function(List<Equipment>) get dataSink => _equipmentController.sink.add;

  set query(query) => _debouncer.value = query;

  EquipmentApi() {
    _debouncer = Debouncer<String>(
      duration: const Duration(milliseconds: 500),
      onValue: (value) async => dataSink(await EquipmentApi.findByQuery()),
    );
  }

  // STATICS
  static Future<List<Equipment>> findByQuery() async {
    try {
      String url = '$API_URL/equipments';
      final res = await http.get(Uri.parse(url));

      final data = json.decode(res.body);

      if (res.statusCode == 500) throw Exception(data['message']);

      return List.from(data.map((e) => Equipment.fromJson(e)));
    } catch (e) {
      log(e.toString());
    }

    return [];
  }

  static Future<List<Equipment>> findAll({int? page = 0, int? limit = 20, int? placeId}) async {
    try {
      String url = '$API_URL/equipments?page=$page&limit=$limit';

      if (placeId != null) {
        url += '&placeId=$placeId';
      }

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
