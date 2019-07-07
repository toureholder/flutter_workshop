import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_workshop/base/base_api.dart';
import 'package:flutter_workshop/model/donation/donation.dart';
import 'package:flutter_workshop/model/donation/donation_api_response.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

DonationApiResponse parseDonations(Map<String, dynamic> json) =>
    DonationApiResponse.fromJson(json);

class DonationApi extends BaseApi {
  DonationApi({@required http.Client client}) : super(client: client);

  Future<List<Donation>> getDonations() async {
    final String url = '${baseUrl}listings/categories/33';
    final http.Response response = await get(url);
    final Map<String, dynamic> json = jsonDecode(response.body);
    final DonationApiResponse dto = await compute(parseDonations, json);
    return dto.donations;
  }
}
