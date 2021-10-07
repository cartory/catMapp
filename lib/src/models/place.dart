// To parse this JSON data, do
//
//     final place = placeFromJson(jsonString);

import 'dart:convert';

import 'package:catmapp/src/models/user.dart';

class Place {
  Place({
    this.id,
    this.code,
    this.name,
    this.description,
    this.typeid,
    this.photoUrl,
    this.type,
    this.users,
    this.tasks,
    this.places,
  });

  int? id;
  String? code;
  String? name;
  String? description;
  int? typeid;
  String? photoUrl;
  Type? type;
  List<User>? users;
  List<dynamic>? tasks;
  List<Place>? places;

  factory Place.fromRawJson(String str) => Place.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Place.fromJson(Map<String, dynamic> json) => Place(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        description: json["description"],
        typeid: json["Typeid"],
        photoUrl: json["photoUrl"],
        type: Type.fromJson(json["type"]),
        users: List<User>.from(json["users"].map((x) => x)),
        tasks: List<dynamic>.from(json["tasks"].map((x) => x)),
        places: json["places"] == null ? null : List<Place>.from(json["places"].map((x) => Place.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "description": description,
        "Typeid": typeid,
        "photoUrl": photoUrl,
        "type": type!.toJson(),
        "users": List<User>.from(users!.map((x) => x)),
        "tasks": List<dynamic>.from(tasks!.map((x) => x)),
        "places": places == null ? null : List<dynamic>.from(places!.map((x) => x.toJson())),
      };
}

class Type {
  Type({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory Type.fromRawJson(String str) => Type.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Type.fromJson(Map<String, dynamic> json) => Type(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
