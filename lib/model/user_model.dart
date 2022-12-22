// To parse this JSON data, do
//
//     final Myuser = MyuserFromJson(jsonString);

import 'dart:convert';

MyUser MyuserFromJson(String str) => MyUser.fromJson(json.decode(str));

String MyuserToJson(MyUser data) => json.encode(data.toJson());

class MyUser {
  MyUser({
    required this.id,
    required this.name,
    this.phone,
    required this.email,
  });

  String id;
  String name;
  String? phone;
  String email;

  factory MyUser.fromJson(Map<String, dynamic> json) => MyUser(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "email": email,
      };
}
