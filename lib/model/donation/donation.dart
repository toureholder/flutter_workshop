import 'package:flutter_workshop/model/donation/donation_image.dart';
import 'package:flutter_workshop/model/user/user.dart';

class Donation {
  Donation.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        user = User.fromJson(json['user']),
        images = DonationImage.fromJsonList(json['listing_images']);

  Donation.fake()
      : id = 1,
        title = 'Donation',
        description =
            'Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
        images = DonationImage.fakeList(),
        user = User.fake();

  final int id;
  final String title;
  final String description;
  final User user;
  final List<DonationImage> images;

  static List<Donation> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((dynamic json) => Donation.fromJson(json)).toList();

  static List<Donation> fakeList() {
    final List<Donation> list = <Donation>[];

    for (int i = 0; i < 5; i++) {
      list.add(Donation.fake());
    }

    return list;
  }
}
