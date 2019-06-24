import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_workshop/config/platform_independent_constants.dart';
import 'package:test/test.dart';

void main() {
  const defaultWaitForTimeout = Duration(seconds: 10);

  group('Workshop app', () {

    final appBarTextFinder = find.text('Login');

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
    });

    test('starts at the Home page', () async {
      final loginButtonFinder = find.byValueKey(homeLoginButtonValueKey);

      await driver.tap(loginButtonFinder);

      await driver.waitFor(appBarTextFinder, timeout: defaultWaitForTimeout);
    });
  });
}