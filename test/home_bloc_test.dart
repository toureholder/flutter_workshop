import 'package:flutter_workshop/feature/home/home_bloc.dart';
import 'package:flutter_workshop/model/donation/donation.dart';
import 'package:flutter_workshop/model/donation/donation_api.dart';
import 'package:flutter_workshop/model/user/user.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'dart:async';

import 'test_util/mocks.dart';

class MockDonationApi extends Mock implements DonationApi {}

class MockHomeResponseStreamController extends Mock
    implements StreamController<List<Donation>> {}

class MockHomeResponseStreamSink extends Mock
    implements StreamSink<List<Donation>> {}

void main() {
  MockHomeResponseStreamController _mockController;
  MockHomeResponseStreamSink _mockSink;
  MockDonationApi _mockDonationApi;
  MockSessionProvider _mockSessionProvider;
  MockDiskStorageProvider _mockDiskStorageProvider;
  HomeBloc _bloc;

  setUp(() {
    _mockController = MockHomeResponseStreamController();
    _mockSink = MockHomeResponseStreamSink();
    _mockDonationApi = MockDonationApi();
    _mockSessionProvider = MockSessionProvider();
    _mockDiskStorageProvider = MockDiskStorageProvider();
    _bloc = HomeBloc(
        controller: _mockController,
        donationApi: _mockDonationApi,
        sessionProvider: _mockSessionProvider,
        diskStorageProvider: _mockDiskStorageProvider);

    when(_mockController.sink).thenReturn(_mockSink);
  });

  test('calls donation api', () async {
    await _bloc.loadDonations();
    verify(_mockDonationApi.getDonations());
  });

  test('adds the donations the api returns to stream sink', () async {
    when(_mockDonationApi.getDonations())
        .thenAnswer((_) async => Donation.fakeList());

    await _bloc.loadDonations();
    verify(_mockSink.add(any));
  });

  test('adds error to stream sink if api throws an exception', () async {
    when(_mockDonationApi.getDonations()).thenThrow(Error());

    await _bloc.loadDonations();
    verify(_mockSink.addError(any)).called(1);
  });

  test('recovers user from disk storage', () async {
    when(_mockDiskStorageProvider.getUser()).thenReturn(User.fake());
    expect(await _bloc.loadCurrentUser(), isA<User>());
  });

  test('logs user out from session', () async {
    _bloc.logout();
    verify(_mockSessionProvider.logUserOut()).called(1);
  });

  test('closes stream', () async {
    await _bloc.dispose();
    verify(_mockController.close()).called(1);
  });

  tearDown(() {
    _mockController.close();
  });
}
