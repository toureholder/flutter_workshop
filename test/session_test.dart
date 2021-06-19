import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:flutter_workshop/service/session.dart';
import 'package:flutter_workshop/model/user/user.dart';
import 'test_util/mocks.dart';
import 'test_util/fakes.dart';

void main() {
  late MockDiskStorageProvider mockStorage;
  late Session session;

  setUp(() {
    mockStorage = MockDiskStorageProvider();
    session = Session(diskStorageProvider: mockStorage);

    registerFallbackValue(FakeUser());
  });

  group('Session', () {
    test('should be created', () {
      expect(session, isNot(null));
    });

    group('#logUserIn', () {
      test('should persist access token', () async {
        // Given
        const token = 'i am a token';
        when(() => mockStorage.setAccessToken(any()))
            .thenAnswer((_) async => true);

        when(() => mockStorage.setUser(any())).thenAnswer((_) async => true);

        // When
        await session.logUserIn(token, const User.fake());

        // Then
        verify(() => mockStorage.setAccessToken(token));
      });

      test('should persist user', () async {
        // Given
        const user = User.fake();
        when(() => mockStorage.setAccessToken(any()))
            .thenAnswer((_) async => true);
        when(() => mockStorage.setUser(any())).thenAnswer((_) async => true);

        // When
        await session.logUserIn('any token', user);

        // Then
        verify(() => mockStorage.setUser(user));
      });
    });

    group('#logUserOut', () {
      test('should clear user and token', () async {
        // Given
        when(() => mockStorage.clearToken()).thenAnswer((_) async => true);
        when(() => mockStorage.clearUser()).thenAnswer((_) async => true);

        // When
        await session.logUserOut();

        // Then
        verify(() => mockStorage.clearToken());
        verify(() => mockStorage.clearUser());
      });
    });
  });
}
