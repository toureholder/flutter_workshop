import 'dart:convert';

class User {
  int id;
  String name;
  String avatarUrl;

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

  String toEncodedJson() {
    Map<String, dynamic> json = {
      idJsonKey: id,
      nameJsonKey: name,
      avatarUrlJsonKey: avatarUrl
    };
    return jsonEncode(json);
  }

  static String idJsonKey = 'id';
  static String nameJsonKey = 'name';
  static String avatarUrlJsonKey = 'image_url';
}
