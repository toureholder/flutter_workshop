import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_workshop/config/platform_independent_constants.dart';
import 'package:test/test.dart';

void main() {
  const defaultWaitForTimeout = Duration(seconds: 10);

  group('Workshop app', () {
    final passwordVisibilityToggleFinder =
        find.byValueKey(loginPasswordVisibilityToggleValueKey);
    final passwordVisibilityToggleObscureFinder =
        find.byValueKey(loginPasswordVisibilityToggleObscureValueKey);
    final passwordVisibilityToggleVisibleFinder =
        find.byValueKey(loginPasswordVisibilityToggleVisibleValueKey);

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

    test('password visibility toggle shows correct icon', () async {
      final homeLoginButtonFinder = find.byValueKey(homeLoginButtonValueKey);

      await driver.tap(homeLoginButtonFinder);

      await driver.waitFor(passwordVisibilityToggleObscureFinder,
          timeout: defaultWaitForTimeout);

      await driver.tap(passwordVisibilityToggleFinder);

      await driver.waitFor(passwordVisibilityToggleVisibleFinder,
          timeout: defaultWaitForTimeout);

      await driver.tap(passwordVisibilityToggleFinder);

      await driver.waitFor(passwordVisibilityToggleObscureFinder,
          timeout: defaultWaitForTimeout);
    });
  });
}
