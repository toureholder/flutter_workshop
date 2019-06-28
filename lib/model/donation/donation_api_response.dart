import 'package:flutter_workshop/model/donation/donation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'donation_api_response.g.dart';

@JsonSerializable()
class DonationApiResponse {
  @JsonKey(name: 'listings')
  final List<Donation> donations;

  DonationApiResponse(this.donations);

  factory DonationApiResponse.fromJson(Map<String, dynamic> json) =>
      _$DonationApiResponseFromJson(json);
}
