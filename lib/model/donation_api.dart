import 'package:flutter_workshop/model/donation.dart';
import 'package:flutter_workshop/model/donation_api_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DonationApi {
  Future<List<Donation>> getDonations() async {
    final url = 'https://giv-api.herokuapp.com/listings/categories/27';
    final response = await http.get(url);
    final json = jsonDecode(response.body);
    final DonationApiResponse dto = DonationApiResponse.fromJson(json);
    return dto.donations;
  }
}
