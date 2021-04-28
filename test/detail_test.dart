import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_workshop/feature/detail/detail.dart';
import 'package:flutter_workshop/feature/login/login_bloc.dart';
import 'package:flutter_workshop/model/donation/donation.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';

import 'test_util/mocks.dart';
import 'test_util/test_util.dart';

void main() {
  final Donation _fakeDonation = Donation.fake();

  final Widget _testableWidget = TestUtil.makeTestableWidget(
      dependencies: [
        Provider<LoginBloc>(create: (_) => MockLoginBloc()),
      ],
      subject: Detail(
        donation: _fakeDonation,
      ));

  testWidgets('displays donation information', (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(_testableWidget);

      expect(find.text(_fakeDonation.title), findsOneWidget);
      expect(find.text(_fakeDonation.description), findsOneWidget);
    });
  });

  testWidgets('displays user information', (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(_testableWidget);

      expect(find.text(_fakeDonation.user.name), findsOneWidget);
    });
  });
}
