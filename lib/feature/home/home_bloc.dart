import 'dart:async';

import 'package:flutter_workshop/model/donation/donation.dart';
import 'package:flutter_workshop/model/donation/donation_api.dart';
import 'package:flutter_workshop/model/user/user.dart';
import 'package:flutter_workshop/service/disk_storage_provider.dart';
import 'package:meta/meta.dart';

class HomeBloc {
  final DonationApi donationApi;
  final StreamController<List<Donation>> controller;
  final DiskStorageProvider diskStorageProvider;

  HomeBloc(
      {@required this.donationApi,
      @required this.controller,
      @required this.diskStorageProvider});

  Stream<List<Donation>> get stream => controller.stream;

  dispose() => controller.close();

  loadDonations() async {
    try {
      final donations = await donationApi.getDonations();
      controller.sink.add(donations);
    } catch (error) {
      controller.sink.addError(error);
    }
  }

  Future<User> loadCurrentUser() async => diskStorageProvider.getUser();
}
