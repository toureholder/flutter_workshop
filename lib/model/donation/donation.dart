import 'package:flutter_workshop/model/donation/donation_image.dart';
import 'package:flutter_workshop/model/user/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'donation.g.dart';

@JsonSerializable()
class Donation {
  final int? id;
  final String? title;
  final String? description;
  final User user;
  @JsonKey(name: 'listing_images')
  final List<DonationImage> images;

  Donation(
    this.id,
    this.title,
    this.description,
    this.user,
    this.images,
  );

  factory Donation.fromJson(Map<String, dynamic> json) =>
      _$DonationFromJson(json);

  factory Donation.fake({User? user}) {
    const id = 1;
    const title = 'Donation';
    const description =
        'Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua';
    final images = DonationImage.fakeList();
    final finalUser = user ?? const User.fake();

    return Donation(id, title, description, finalUser, images);
  }

  static List<Donation> fakeList() {
    final List<Donation> list = <Donation>[];

    for (int i = 0; i < 5; i++) {
      list.add(Donation.fake());
    }

    return list;
  }
}
