import 'dart:async';

import 'package:flutter_workshop/model/donation/donation.dart';
import 'package:flutter_workshop/model/donation/donation_api.dart';
import 'package:flutter_workshop/model/user/user.dart';
import 'package:flutter_workshop/service/disk_storage_provider.dart';
import 'package:flutter_workshop/service/session_provider.dart';
import 'package:meta/meta.dart';

class HomeBloc {
  HomeBloc({
    @required this.donationApi,
    @required this.controller,
    @required this.diskStorageProvider,
    @required this.sessionProvider,
  });

  final DonationApi donationApi;
  final StreamController<List<Donation>> controller;
  final DiskStorageProvider diskStorageProvider;
  final SessionProvider sessionProvider;

  Stream<List<Donation>> get stream => controller.stream;

  Future<void> dispose() => controller.close();

  Future<void> loadDonations() async {
    try {
      final List<Donation> donations = await donationApi.getDonations();
      controller.sink.add(donations);
    } catch (error) {
      controller.sink.addError(error);
    }
  }

  Future<User> loadCurrentUser() async => diskStorageProvider.getUser();

  Future<List<bool>> logout() async => sessionProvider.logUserOut();
}
