import 'package:flutter_workshop/model/donation/donation.dart';
import 'package:flutter_workshop/model/donation/donation_api.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

void main() {
  final MockClient _mockClient = MockClient();
  final DonationApi _donationApi = DonationApi(client: _mockClient);

  test('returns a list of donations if the http call succeeds', () async {
    const String _fakeResponseBody =
        '[{"id":127,"title":"Livro A vida do bebê","description":"Livro do pediatra Dr Rinaldo de Lamare","geonames_city_id":"6698115","geonames_state_id":"3463504","geonames_country_id":"3469034","is_active":true,"updated_at":"2019-04-18T01:47:14.841Z","user":{"id":80,"name":"Leila Fernandes","country_calling_code":"55","phone_number":"61992457329","image_url":"https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=2184645801651822\u0026width=640\u0026ext=1558106954\u0026hash=AeSR9xd7OYoqRFTX","bio":null,"created_at":"2019-04-17T15:29:14.211Z"},"categories":[{"id":33,"simple_name":"Livros","canonical_name":"Livros"}],"listing_images":[{"id":444,"url":"https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/listings%2F1555551883274-89d414c0-5970-11e9-f3fe-f96200bfa261.jpg?alt=media\u0026token=e8a51fc1-4388-4348-babe-693b9c1b99ae","position":0}]}]';

    when(_mockClient.get(any!, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(_fakeResponseBody, 200));

    expect(await _donationApi.getDonations(), isA<List<Donation>>());
  });
}
