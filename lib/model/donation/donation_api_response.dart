import 'package:flutter_workshop/model/donation/donation.dart';

class DonationApiResponse {
  final List<Donation> donations;

  DonationApiResponse(this.donations);

  DonationApiResponse.fromJson(Map<String, dynamic> json)
      : donations = Donation.fromJsonList(json['listings']);
}
