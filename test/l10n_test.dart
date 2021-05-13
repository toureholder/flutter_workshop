import 'package:test/test.dart';

import 'package:flutter_workshop/config/l10n.dart';

void main() {
  group('StringLocalizationsDelegate', () {
    group('#shouldReload', () {
      test('should return false', () {
        // Given
        const delegate = StringLocalizationsDelegate();
        const old = StringLocalizationsDelegate();

        expect(delegate.shouldReload(old), false);
      });
    });
  });
}
