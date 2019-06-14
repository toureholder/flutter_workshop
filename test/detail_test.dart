import 'package:flutter_workshop/feature/detail/detail.dart';
import 'package:flutter_workshop/model/donation/donation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_test_utils/image_test_utils.dart';
import 'test_util/test_util.dart';

void main() {
  final _fakeDonation = Donation.fake();

  final _testableWidget = TestUtil.makeTestableWidget(
      subject: Detail(
    donation: _fakeDonation,
  ));

  testWidgets('displays donation information', (WidgetTester tester) async {
    provideMockedNetworkImages(() async {
      await tester.pumpWidget(_testableWidget);

      expect(find.text(_fakeDonation.title), findsOneWidget);
      expect(find.text(_fakeDonation.description), findsOneWidget);
    });
  });

  testWidgets('displays user information', (WidgetTester tester) async {
    provideMockedNetworkImages(() async {
      await tester.pumpWidget(_testableWidget);

      expect(find.text(_fakeDonation.user.name), findsOneWidget);
    });
  });
}
