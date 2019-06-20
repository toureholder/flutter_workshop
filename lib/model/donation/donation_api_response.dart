import 'package:flutter_workshop/model/donation/donation.dart';

class DonationApiResponse {
  DonationApiResponse.fromJson(Map<String, dynamic> json)
      : donations = Donation.fromJsonList(json['listings']);

  final List<Donation> donations;
}
