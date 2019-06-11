import 'package:flutter_workshop/model/user/user.dart';
import 'package:test/test.dart';

void main() {
  final _encodedUser = '{"id":1,"name":"Test user","image_url":"https://randomuser.me/api/portraits/women/2.jpg"}';

  test('decodes user', () {
    final User result = User.fromEncodedJson(_encodedUser);
    expect(result.name, 'Test user');
  });

  test('encodes user', () {
    final String result = User.fake().toEncodedJson();
    expect(result, _encodedUser);
  });
}
