import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  int id;
  String name;
  @JsonKey(name: 'image_url')
  String avatarUrl;

  User(this.id, this.name, this.avatarUrl);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  factory User.fromEncodedJson(String encoded) =>
      encoded == null ? null : User.fromJson(jsonDecode(encoded));

  User.fake()
      : id = 1,
        name = 'Test user',
        avatarUrl = 'https://randomuser.me/api/portraits/women/2.jpg';

  Map<String, dynamic> toJson() => _$UserToJson(this);

  String toEncodedJson() => jsonEncode(toJson());

  static String idJsonKey = 'id';
  static String nameJsonKey = 'name';
  static String avatarUrlJsonKey = 'image_url';
}
