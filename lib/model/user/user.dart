import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  int id;
  String name;
  @JsonKey(name: 'image_url')
  String avatarUrl;

  User(
    this.id,
    this.name,
    this.avatarUrl,
  );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  factory User.fromEncodedJson(String encoded) =>
      encoded == null ? null : User.fromJson(jsonDecode(encoded));

  User.fake({
    String avatarUrl =
        'https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/randomuser_women_30.jpeg?alt=media&token=823cbd79-f1f1-4c83-8f6d-8f8fea537f2c',
  })  : id = 1,
        name = 'Eve Holt',
        avatarUrl = avatarUrl;

  Map<String, dynamic> toJson() => _$UserToJson(this);

  String toEncodedJson() => jsonEncode(toJson());

  static String idJsonKey = 'id';
  static String nameJsonKey = 'name';
  static String avatarUrlJsonKey = 'image_url';
}
