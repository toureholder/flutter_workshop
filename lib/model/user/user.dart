import 'dart:convert';

class User {
  User.fromJson(Map<String, dynamic> json)
      : id = json[idJsonKey],
        name = json[nameJsonKey],
        avatarUrl = json[avatarUrlJsonKey];

  factory User.fromEncodedJson(String encoded) =>
      encoded == null ? null : User.fromJson(jsonDecode(encoded));

  User.fake()
      : id = 1,
        name = 'Test user',
        avatarUrl = 'https://randomuser.me/api/portraits/women/2.jpg';

  int id;
  String name;
  String avatarUrl;

  String toEncodedJson() => jsonEncode(<String, dynamic>{
        idJsonKey: id,
        nameJsonKey: name,
        avatarUrlJsonKey: avatarUrl
      });

  static String idJsonKey = 'id';
  static String nameJsonKey = 'name';
  static String avatarUrlJsonKey = 'image_url';
}
