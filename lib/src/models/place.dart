import 'dart:convert';

class Place {
  Place({
    this.id,
    this.code,
    this.name,
    this.type,
    this.places,
    this.photoUrl,
    this.description,
  });

  int? id;

  String? code;
  String? name;
  String? photoUrl;
  String? description;

  Type? type;
  List<Place>? places;
  List<dynamic>? tasks;

  factory Place.fromRawJson(String str) => Place.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json["id"],
      code: json["code"],
      name: json["name"],
      photoUrl: json["photoUrl"],
      description: json["description"],
      type: Type.fromJson(json["type"]),
      places: json["places"] == null ? null : List<Place>.from(json["places"].map((x) => Place.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "code": code,
      "name": name,
      "photoUrl": photoUrl,
      "description": description,
      "type": type?.toJson(),
      "places": places == null ? null : List.from(places!.map((x) => x.toJson())),
    };
  }
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

  factory Type.fromJson(Map<String, dynamic> json) {
    return Type(id: json["id"], name: json["name"]);
  }

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
