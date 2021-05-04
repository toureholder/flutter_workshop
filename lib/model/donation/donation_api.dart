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
    final String url =
        '${baseUrl}listings/categories/33?state_id=3463504&country_id=3469034&is_hard_filter=true&page=1&per_page=15';
    final http.Response response = await get(url);
    final Map<String, dynamic> json = jsonDecode(response.body);
    final DonationApiResponse dto = parseDonations(json);
    return dto.donations;
  }
}
