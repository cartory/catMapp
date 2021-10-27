import 'dart:convert';

import 'package:catmapp/src/globals.dart' show Place, Type;

class Equipment {
  Equipment({
    this.id,
    this.code,
    this.state,
    this.photoUrl,
    this.description,
    this.observations,
    this.unit,
    this.places,
    this.movements,
  });

  int? id;
  String? code;
  String? state;
  String? photoUrl;
  String? description;
  String? observations;

  Unit? unit;
  List<Place>? places;
  List<Movement>? movements;

  factory Equipment.fromRawJson(String str) => Equipment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Equipment.fromJson(Map<String, dynamic> json) => Equipment(
        id: json["id"],
        code: json["code"],
        state: json["state"],
        photoUrl: json["photoUrl"],
        description: json["description"],
        observations: json["observations"],
        unit: Unit.fromJson(json["unit"]),
        places: List<Place>.from(json["places"].map((x) => Place.fromJson(x))),
        movements: json["movements"] == null ? null : List<Movement>.from(json["movements"].map((x) => Movement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "state": state,
        "photoUrl": photoUrl,
        "description": description,
        "observations": observations,
        "unit": unit!.toJson(),
        "places": List.from(places!.map((x) => x.toJson())),
        "movements": List.from(movements!.map((x) => x.toJson())),
      };
}

class Movement {
  Movement({
    this.id,
    this.reason,
    this.placeTo,
    this.placeFrom,
    this.description,
  });

  int? id;
  String? description;

  Reason? reason;
  Place? placeTo;
  Place? placeFrom;

  factory Movement.fromRawJson(String str) => Movement.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Movement.fromJson(Map<String, dynamic> json) => Movement(
        id: json["id"],
        description: json["description"],
        reason: Reason.fromJson(json["reason"]),
        placeTo: json["placeTo"] == null ? null : Place.fromJson(json["placeTo"]),
        placeFrom: json["placeFrom"] == null ? null : Place.fromJson(json["placeFrom"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "reason": reason?.toJson(),
        "placeTo": placeTo?.toJson(),
        "placeFrom": placeFrom?.toJson(),
      };
}

class Unit extends Type {
  Unit({int? id, String? name}) : super(id: id, name: name);

  factory Unit.fromRawJson(String str) => Unit.fromJson(json.decode(str));
  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(id: json["id"], name: json["name"]);
  }
}

class Reason extends Type {
  Reason({int? id, String? name}) : super(id: id, name: name);

  factory Reason.fromRawJson(String str) => Reason.fromJson(json.decode(str));
  factory Reason.fromJson(Map<String, dynamic> json) {
    return Reason(id: json["id"], name: json["name"]);
  }
}
