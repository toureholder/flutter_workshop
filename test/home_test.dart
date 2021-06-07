import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_workshop/config/platform_independent_constants.dart';
import 'package:flutter_workshop/custom/adaptive_view.dart';
import 'package:flutter_workshop/custom/custom_alert_dialog.dart';
import 'package:flutter_workshop/custom/custom_app_bar.dart';
import 'package:flutter_workshop/custom/custom_button.dart';
import 'package:flutter_workshop/feature/detail/detail.dart';
import 'package:flutter_workshop/feature/home/home.dart';
import 'package:flutter_workshop/feature/login/login.dart';
import 'package:flutter_workshop/feature/login/login_bloc.dart';
import 'package:flutter_workshop/model/donation/donation.dart';
import 'package:flutter_workshop/model/user/user.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';

import 'test_util/mocks.dart';
import 'test_util/test_util.dart';

void main() {
  final TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;

  final MockHomeBloc _mockHomeBloc = MockHomeBloc();
  final MockLoginBloc _mockLoginBloc = MockLoginBloc();
  final MockNavigatorObserver _mockNavigationObserver = MockNavigatorObserver();

  final Widget _testableWidget = TestUtil.makeTestableWidget(
    subject: Home(
      bloc: _mockHomeBloc,
    ),
    dependencies: [
      Provider<LoginBloc>(create: (_) => _mockLoginBloc),
    ],
    navigatorObservers: <NavigatorObserver>[_mockNavigationObserver],
    testingLocale: const Locale('not_supported'),
  );

  final Finder _appBar = find.byType(CustomAppBar);

  group('small screen', () {
    setUp(() {
      binding.window.physicalSizeTestValue = const Size(
        MEDUIM_SCREEN_MIN_WIDTH - 10,
        500,
      );

      binding.window.devicePixelRatioTestValue = 1.0;
    });

    testWidgets('shows circular progress inidicator while loading',
        (WidgetTester tester) async {
      when(_mockHomeBloc.stream).thenAnswer((_) => MockDonationListStream());

      await tester.pumpWidget(_testableWidget);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('loads donations', (WidgetTester tester) async {
      await tester.pumpWidget(_testableWidget);

      verify(_mockHomeBloc.loadDonations());
    });

    testWidgets('shows list when donations are added to stream',
        (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        final StreamController<List<Donation>> controller =
            StreamController<List<Donation>>.broadcast();

        when(_mockHomeBloc.stream).thenAnswer((_) => controller.stream);

        await tester.pumpWidget(_testableWidget);

        controller.sink.add(Donation.fakeList());

        await tester.pump(Duration.zero);

        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.byType(ListView), findsOneWidget);

        await controller.close();
      });
    });

    testWidgets('navigates to login screen', (WidgetTester tester) async {
      when(_mockLoginBloc.stream).thenAnswer((_) => MockLoginResponseStream());

      await tester.pumpWidget(_testableWidget);
      final Finder loginButton = find.byKey(Home.loginButtonKey);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      verify(_mockNavigationObserver.didPush(any!, any));
      expect(find.byType(Login), findsOneWidget);
    });

    testWidgets('navigates to detail screen', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        final StreamController<List<Donation>> controller =
            StreamController<List<Donation>>.broadcast();

        when(_mockHomeBloc.stream).thenAnswer((_) => controller.stream);

        await tester.pumpWidget(_testableWidget);

        controller.sink.add(Donation.fakeList());

        await tester.pump(Duration.zero);

        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.byType(ListView), findsOneWidget);

        final firstItem = find.byKey(const Key('${homeListItemValueKey}0'));
        expect(firstItem, findsOneWidget);

        await tester.tap(firstItem);
        await tester.pumpAndSettle();

        verify(_mockNavigationObserver.didPush(any!, any));
        expect(find.byType(Detail), findsOneWidget);

        await controller.close();
      });
    });

    testWidgets('displays user avatar in app bar if user is logged in',
        (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        when(_mockHomeBloc.loadCurrentUser())
            .thenAnswer((_) async => User.fake());

        await tester.pumpWidget(_testableWidget);
        await tester.pump(Duration.zero);

        expect(
          find.descendant(of: _appBar, matching: find.byType(CircleAvatar)),
          findsOneWidget,
        );
      });
    });

    testWidgets('displays login button in app bar if user is not logged in',
        (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        when(_mockHomeBloc.loadCurrentUser()).thenAnswer((_) async => null);

        await tester.pumpWidget(_testableWidget);
        await tester.pump(Duration.zero);

        final Finder textButton = find.byType(PrimaryTextButton);
        final Finder text = TestUtil.findInternationalizedText('login_title');
        final Finder loginButton = find.descendant(
          of: textButton,
          matching: text,
        );

        expect(
          find.descendant(
            of: _appBar,
            matching: loginButton,
          ),
          findsOneWidget,
        );
      });
    });

    testWidgets('shows logout confirmation dialog when user taps avatar',
        (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        when(_mockHomeBloc.loadCurrentUser())
            .thenAnswer((_) async => User.fake());

        await tester.pumpWidget(_testableWidget);
        await tester.pump(Duration.zero);

        final Finder avatar = find.descendant(
          of: _appBar,
          matching: find.byType(CircleAvatar),
        );

        await tester.tap(avatar);
        await tester.pump(Duration.zero);

        final Finder dialog = find.byType(CustomAlertDialog);
        final Finder title =
            TestUtil.findInternationalizedText('logout_confirmation_title');

        expect(
          find.descendant(of: dialog, matching: title),
          findsOneWidget,
        );
      });
    });

    testWidgets('closes logout confirmation dialog when user taps cancel',
        (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        when(_mockHomeBloc.loadCurrentUser())
            .thenAnswer((_) async => User.fake());

        await tester.pumpWidget(_testableWidget);
        await tester.pump(Duration.zero);

        final Finder avatar = find.descendant(
          of: _appBar,
          matching: find.byType(CircleAvatar),
        );

        await tester.tap(avatar);
        await tester.pump(Duration.zero);

        final Finder dialog = find.byType(CustomAlertDialog);
        final Finder cancelButton =
            find.byKey(const Key(logoutDialogCancelButton));

        expect(
          find.descendant(of: dialog, matching: cancelButton),
          findsOneWidget,
        );

        await tester.tap(cancelButton);
        await tester.pump(Duration.zero);

        expect(dialog, findsNothing);
      });
    });

    testWidgets('calls bloc logout with button is tapped',
        (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        when(_mockHomeBloc.loadCurrentUser())
            .thenAnswer((_) async => User.fake());

        await tester.pumpWidget(_testableWidget);
        await tester.pump(Duration.zero);

        final Finder avatar =
            find.descendant(of: _appBar, matching: find.byType(CircleAvatar));

        await tester.tap(avatar);
        await tester.pump(Duration.zero);

        final Finder buttonText = TestUtil.findInternationalizedText(
          'logout_confirmation',
        );

        final Finder button = find.descendant(
          of: find.byType(PrimaryTextButton),
          matching: buttonText,
        );

        await tester.tap(button);

        verify(_mockHomeBloc.logout()).called(1);
      });
    });

    testWidgets('shows error message when an error is added to stream',
        (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        final StreamController<List<Donation>> controller =
            StreamController<List<Donation>>.broadcast();

        when(_mockHomeBloc.stream).thenAnswer((_) => controller.stream);

        await tester.pumpWidget(_testableWidget);

        controller.sink.addError('error');

        await tester.pump(Duration.zero);

        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(
            find.descendant(
                of: find.byType(Center), matching: find.text('error')),
            findsOneWidget);

        await controller.close();
      });
    });
  });

  group('large screen', () {
    setUp(() {
      binding.window.physicalSizeTestValue = const Size(
        LARGE_SCREEN_MIN_WIDTH + 10,
        500,
      );

      binding.window.devicePixelRatioTestValue = 1.0;
    });

    testWidgets('initially shows select item call to action ',
        (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        final StreamController<List<Donation>> controller =
            StreamController<List<Donation>>.broadcast();

        when(_mockHomeBloc.stream).thenAnswer((_) => controller.stream);

        await tester.pumpWidget(_testableWidget);

        controller.sink.add(Donation.fakeList());

        await tester.pump(Duration.zero);

        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.byType(ListView), findsOneWidget);
        expect(find.byKey(Home.largeScreenCTAKey), findsOneWidget);

        await controller.close();
      });
    });

    testWidgets('displays selected item', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        final StreamController<List<Donation>> controller =
            StreamController<List<Donation>>.broadcast();

        when(_mockHomeBloc.stream).thenAnswer((_) => controller.stream);

        await tester.pumpWidget(_testableWidget);

        controller.sink.add(Donation.fakeList());

        await tester.pump(Duration.zero);

        final firstItem = find.byKey(const Key('${homeListItemValueKey}0'));

        await tester.tap(firstItem);
        await tester.pump();

        expect(find.byType(Detail), findsOneWidget);

        await controller.close();
      });
    });
  });
}
