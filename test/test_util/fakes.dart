import 'package:flutter_workshop/model/user/user.dart';
import 'package:mocktail/mocktail.dart';

const String fakeLoginResponseBody =
    '{"long_lived_token":"eyJhb.eyJ1fQ.RcV782ng","user":{"id":9,"name":"Touré (flutter workshop)","country_calling_code":null,"phone_number":null,"image_url":"https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/users%2F9%2Fphotos%2F1557445532146.jpg?alt=media\u0026token=a51f52b4-fd87-4078-89a4-27bedfc0edb8","bio":null,"admin":false,"created_at":"2019-03-27T10:44:45.939Z"}}';

const String fakeLogin422ResponseBody = '{"message":"Invalid credentials"}';

class FakeUser extends Fake implements User {}
