import 'package:flutter_workshop/model/user/user.dart';
import 'package:test/test.dart';

void main() {
  const id = 1;
  const name = 'Test user';
  const imageUrl = 'https://randomuser.me/api/portraits/women/2.jpg';
  const String _encodedUser =
      '{"id":$id,"name":"$name","image_url":"$imageUrl"}';

  test('decodes user', () {
    final User result = User.fromEncodedJson(_encodedUser);
    expect(result.name, name);
  });

  test('encodes user', () {
    final String result = User(id, name, imageUrl).toEncodedJson();
    expect(result, _encodedUser);
  });
}
