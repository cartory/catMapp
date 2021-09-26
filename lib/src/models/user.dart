import 'dart:convert';

class User {
  User({
    this.id,
    this.uid,
    this.name,
    this.email,
    this.password,
    this.photoUrl,
    this.phoneNumber,
  });

  int? id;
  String? uid;
  String? name;
  String? email;
  String? password;
  String? photoUrl;
  String? phoneNumber;

  factory User.fromRawJson(String? str) => User.fromJson(json.decode(str ?? '{}'));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      uid: json["uid"],
      name: json["name"],
      email: json["email"],
      password: json["password"],
      photoUrl: json["photoURL"],
      phoneNumber: json["phoneNumber"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "uid": uid,
      "name": name,
      "email": email,
      "password": password,
      "photoURL": photoUrl,
      "phoneNumber": phoneNumber,
    };
  }
}
