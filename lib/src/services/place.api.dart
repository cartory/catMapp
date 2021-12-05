// ignore_for_file: library_prefixes

import 'dart:io';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as Path;

import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../globals.dart';

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

  static Future<String?> _uploadFile(File img) async {
    try {
      final placeRef = FirebaseStorage.instance.ref().child('places/${Path.basename(img.path)}');
      placeRef.putFile(img);

      return await placeRef.getDownloadURL();
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  static Future<bool> addPlace(Place place, File? img) async {
    place.type = GetInstance().find<GetPlace>().selectedPlace.type;

    try {
      if (img != null) {
        place.photoUrl = await _uploadFile(img);
      }

      final res = await http.post(
        Uri.parse('$API_URL/places'),
        body: place.toRawJson(),
        headers: {"Content-Type": "application/json"},
      );

      final data = json.decode(res.body);

      if (res.statusCode == 500) throw Exception(data['message']);
      return true;
    } catch (e) {
      log(e.toString());
    }

    return false;
  }
}
