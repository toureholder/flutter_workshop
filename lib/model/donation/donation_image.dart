import 'package:json_annotation/json_annotation.dart';

part 'donation_image.g.dart';

@JsonSerializable()
class DonationImage {
  final String url;

  DonationImage(this.url);

  factory DonationImage.fromJson(Map<String, dynamic> json) =>
      _$DonationImageFromJson(json);

  static List<DonationImage> fakeList() => <DonationImage>[
        DonationImage('https://picsum.photos/id/100/500/500'),
        DonationImage('https://picsum.photos/id/200/500/500'),
        DonationImage('https://picsum.photos/id/300/500/500'),
        DonationImage('https://picsum.photos/id/400/500/500'),
        DonationImage('https://picsum.photos/id/500/500/500'),
      ];
}
