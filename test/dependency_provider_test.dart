import 'package:flutter_workshop/base/dependency_provider.dart';
import 'package:test/test.dart';

void main() {
  test('should throw when initialized with null argument', () {
    expect(() => DependencyProvider(child: null),
        throwsA(const TypeMatcher<AssertionError>()));
  });
}