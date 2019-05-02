import 'package:flutter_workshop/model/donation_image.dart';
import 'package:flutter_workshop/model/user.dart';

class Donation {
  final int id;
  final String title;
  final String description;
  final User user;
  final List<DonationImage> images;

  Donation(this.id, this.title, this.description, this.user, this.images);

  Donation.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        user = User.fromJson(json['user']),
        images = DonationImage.fromJsonList(json['listing_images']);

  Donation.fake()
      : id = 1,
        title = "Donation",
        description =
            "Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua",
        images = DonationImage.fakeList(),
        user = User.fake();

  static List<Donation> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((json) => Donation.fromJson(json)).toList();

  static List<Donation> fakeList() {
    final List<Donation> list = [];

    for (var i = 0; i < 5; i++) {
      list.add(Donation.fake());
    }

    return list;
  }
}
