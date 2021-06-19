import 'dart:async';

import 'package:flutter_workshop/feature/home/home_bloc.dart';
import 'package:flutter_workshop/model/donation/donation.dart';
import 'package:flutter_workshop/model/donation/donation_api.dart';
import 'package:flutter_workshop/model/user/user.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

class MockDonationApi extends Mock implements DonationApi {}

class MockHomeResponseStreamController extends Mock
    implements StreamController<List<Donation>> {}

class MockHomeResponseStreamSink extends Mock
    implements StreamSink<List<Donation>> {}

void main() {
  late MockHomeResponseStreamController mockController;
  late MockHomeResponseStreamSink mockSink;
  late MockDonationApi mockDonationApi;
  late MockSessionProvider mockSessionProvider;
  late MockDiskStorageProvider mockDiskStorageProvider;
  late HomeBloc bloc;

  setUp(() {
    mockController = MockHomeResponseStreamController();
    mockSink = MockHomeResponseStreamSink();
    mockDonationApi = MockDonationApi();
    mockSessionProvider = MockSessionProvider();
    mockDiskStorageProvider = MockDiskStorageProvider();
    bloc = HomeBloc(
      controller: mockController,
      donationApi: mockDonationApi,
      sessionProvider: mockSessionProvider,
      diskStorageProvider: mockDiskStorageProvider,
    );

    when(() => mockController.sink).thenReturn(mockSink);
    final stream = StreamController<List<Donation>>.broadcast().stream;
    when(() => mockController.stream).thenAnswer((_) => stream);

    when(() => mockController.close()).thenAnswer((_) async => null);
  });

  test('calls donation api', () async {
    await bloc.loadDonations();

    verify(() => mockDonationApi.getDonations());
  });

  test('adds the donations the api returns to stream sink', () async {
    when(() => mockDonationApi.getDonations())
        .thenAnswer((_) async => Donation.fakeList());

    await bloc.loadDonations();
    verify(() => mockSink.add(any()));
  });

  test('adds error to stream sink if api throws an exception', () async {
    when(() => mockDonationApi.getDonations()).thenThrow(Error());

    await bloc.loadDonations();
    verify(() => mockSink.addError(any())).called(1);
  });

  test('recovers user from disk storage', () async {
    const user = User.fake();
    when(() => mockDiskStorageProvider.getUser()).thenReturn(user);
    final recoveredUser = await bloc.loadCurrentUser();
    expect(recoveredUser, user);
  });

  test('logs user out from session', () async {
    when(() => mockSessionProvider.logUserOut())
        .thenAnswer((_) async => [true]);

    await bloc.logout();

    verify(() => mockSessionProvider.logUserOut()).called(1);
  });

  test('gets contoller stream', () async {
    await bloc.dispose();
    expect(bloc.stream, isA<Stream<List<Donation>>>());
  });

  test('closes stream', () async {
    await bloc.dispose();
    verify(() => mockController.close()).called(1);
  });

  tearDown(() {
    mockController.close();
  });
}
