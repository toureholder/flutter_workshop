import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_workshop/service/session.dart';
import 'package:flutter_workshop/model/user/user.dart';
import 'test_util/mocks.dart';

void main() {
  MockDiskStorageProvider _mockStorage;
  Session _session;

  setUp(() {
    _mockStorage = MockDiskStorageProvider();
    _session = Session(diskStorageProvider: _mockStorage);
  });

  group('Session', () {
    test('should be created', () {
      expect(_session, isNot(null));
    });

    group('#logUserIn', () {
      test('should persist access token', () async {
        // Given
        const token = 'i am a token';
        when(_mockStorage.setAccessToken(any)).thenAnswer((_) async => true);
        when(_mockStorage.setUser(any)).thenAnswer((_) async => true);

        // When
        await _session.logUserIn(token, User.fake());

        // Then
        verify(_mockStorage.setAccessToken(token));
      });

      test('should persist user', () async {
        // Given
        final user = User.fake();
        when(_mockStorage.setAccessToken(any)).thenAnswer((_) async => true);
        when(_mockStorage.setUser(any)).thenAnswer((_) async => true);

        // When
        await _session.logUserIn('any token', user);

        // Then
        verify(_mockStorage.setUser(user));
      });
    });

    group('#logUserOut', () {
      test('should clear user and token', () async {
        // Given
        when(_mockStorage.clearToken()).thenAnswer((_) async => true);
        when(_mockStorage.clearUser()).thenAnswer((_) async => true);

        // When
        await _session.logUserOut();

        // Then
        verify(_mockStorage.clearToken());
        verify(_mockStorage.clearUser());
      });
    });
  });
}
