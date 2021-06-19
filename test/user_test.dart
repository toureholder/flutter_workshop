import 'package:flutter_workshop/model/user/user.dart';
import 'package:test/test.dart';

void main() {
  const id = 1;
  const name = 'Test user';
  const imageUrl = 'https://randomuser.me/api/portraits/women/2.jpg';
  const String encodedUser =
      '{"id":$id,"name":"$name","image_url":"$imageUrl"}';

  test('decodes user', () {
    final User result = User.fromEncodedJson(encodedUser);
    expect(result.name, name);
  });

  test('encodes user', () {
    final String result = const User(id, name, imageUrl).toEncodedJson();
    expect(result, encodedUser);
  });

  test('implements props', () {
    expect(const User.fake().props, isNotNull);
  });
}
