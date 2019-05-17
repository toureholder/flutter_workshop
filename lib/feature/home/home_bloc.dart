import 'dart:async';

import 'package:flutter_workshop/model/donation/donation.dart';
import 'package:flutter_workshop/model/donation/donation_api.dart';

class HomeBloc {
  final StreamController _controller = StreamController<List<Donation>>();

  get stream => _controller.stream;

  dispose() {
    _controller.close();
  }

  loadDonations() async {
    try {
      final donations = await DonationApi().getDonations();
      _controller.sink.add(donations);
    } catch (error) {
      _controller.sink.addError(error);
    }
  }
}