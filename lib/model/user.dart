class User {
  final int id;
  final String name;
  final String avatarUrl;

  User(this.id, this.name, this.avatarUrl);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        avatarUrl = json['image_url'];

  User.fake()
      : id = 1,
        name = 'Test user',
        avatarUrl = 'https://randomuser.me/api/portraits/women/2.jpg';
}
