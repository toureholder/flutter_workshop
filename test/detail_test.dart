import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_workshop/custom/custom_app_bar.dart';
import 'package:flutter_workshop/feature/detail/detail.dart';
import 'package:flutter_workshop/feature/login/login_bloc.dart';
import 'package:flutter_workshop/model/donation/donation.dart';
import 'package:flutter_workshop/model/user/user.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';

import 'test_util/mocks.dart';
import 'test_util/test_util.dart';

void main() {
  Widget makeTestableWidget(Detail detailWdiget) {
    return TestUtil.makeTestableWidget(
      dependencies: [
        Provider<LoginBloc>(create: (_) => MockLoginBloc()),
      ],
      subject: detailWdiget,
    );
  }

  group('showAppBar', () {
    testWidgets('shows app bar by default', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        final fakeDonation = Donation.fake();
        await tester.pumpWidget(
          makeTestableWidget(
            Detail(
              donation: fakeDonation,
            ),
          ),
        );

        expect(find.byType(CustomAppBar), findsOneWidget);
      });
    });

    testWidgets('hides app bar if showAppBar is false',
        (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        final fakeDonation = Donation.fake();
        await tester.pumpWidget(
          makeTestableWidget(
            Detail(
              donation: fakeDonation,
              showAppBar: false,
            ),
          ),
        );

        expect(find.byType(CustomAppBar), findsNothing);
      });
    });
  });

  testWidgets('displays donation information', (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      final fakeDonation = Donation.fake();
      await tester.pumpWidget(
        makeTestableWidget(
          Detail(
            donation: fakeDonation,
          ),
        ),
      );

      expect(find.text(fakeDonation.title), findsOneWidget);
      expect(find.text(fakeDonation.description), findsOneWidget);
    });
  });

  testWidgets('displays user information', (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      final fakeDonation = Donation.fake();
      await tester.pumpWidget(
        makeTestableWidget(
          Detail(
            donation: fakeDonation,
          ),
        ),
      );

      expect(find.text(fakeDonation.user.name), findsOneWidget);
    });
  });

  testWidgets('displays first letter of user\'s name if user has no image',
      (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      final fakeDonation = Donation.fake(user: User.fake(avatarUrl: null));
      await tester.pumpWidget(
        makeTestableWidget(
          Detail(
            donation: fakeDonation,
          ),
        ),
      );

      expect(
        find.text(Donation.fake().user.name[0]),
        findsOneWidget,
      );
    });
  });
}
