import 'dart:async';

import 'package:flutter_workshop/model/donation/donation.dart';
import 'package:flutter_workshop/model/donation/donation_api.dart';

class HomeBloc {
  final StreamController controller = StreamController<List<Donation>>();

  dispose() {
    controller.close();
  }

  loadDonations() async {
    try {
      final donations = await DonationApi().getDonations();
      controller.sink.add(donations);
    } catch (error) {
      controller.sink.addError(error);
    }
  }
}