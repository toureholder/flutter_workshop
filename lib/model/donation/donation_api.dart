import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_workshop/base/base_api.dart';
import 'package:flutter_workshop/model/donation/donation.dart';
import 'package:flutter_workshop/model/donation/donation_api_response.dart';
import 'package:meta/meta.dart';

class DonationApi extends BaseApi {
  DonationApi({@required http.Client client}) : super(client: client);

  Future<List<Donation>> getDonations() async {
    final url = '${baseUrl}listings/categories/33';
    final response = await get(url);
    final json = jsonDecode(response.body);
    final DonationApiResponse dto = DonationApiResponse.fromJson(json);
    return dto.donations;
  }
}
