import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_workshop/base/base_api.dart';
import 'package:flutter_workshop/model/donation/donation.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class DonationApi extends BaseApi {
  DonationApi({@required http.Client client}) : super(client: client);

  Future<List<Donation>> getDonations() async {
    final String url = '${baseUrl}users/4/listings';
    final http.Response response = await get(url);
    final List<dynamic> json = jsonDecode(response.body);
    return json.map((e) => Donation.fromJson(e)).toList();
  }
}
