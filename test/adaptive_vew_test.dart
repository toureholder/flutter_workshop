import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_workshop/custom/adaptive_view.dart';
import 'package:flutter_workshop/feature/login/login_bloc.dart';
import 'package:provider/provider.dart';

import 'test_util/mocks.dart';
import 'test_util/test_util.dart';

void main() {
  Widget makeTestableWidget({
    Widget? smallView,
    Widget? mediumView,
    Widget? largeView,
    FormFactor? formFactor,
  }) {
    return TestUtil.makeTestableWidget(
      dependencies: [
        Provider<LoginBloc>(create: (_) => MockLoginBloc()),
      ],
      subject: AdaptiveView(
        smallView: smallView,
        mediumView: mediumView,
        largeView: largeView,
        forcedFormFactor: formFactor,
      ),
    );
  }

  group('AdaptiveView', () {
    const smallViewKey = Key('test small view');
    const mediumViewKey = Key('test medium view');
    const largeViewKey = Key('test large view');

    testWidgets('throws AsserionEssor when all views are null',
        (WidgetTester tester) async {
      expect(() => makeTestableWidget(), throwsAssertionError);
    });

    testWidgets(
      'is created',
      (WidgetTester tester) async {
        final testableWidget = makeTestableWidget(smallView: Container());

        await tester.pumpWidget(testableWidget);

        expect(testableWidget, isNot(null));
      },
    );

    group('for small form factors', () {
      const formFactor = FormFactor.small;

      testWidgets(
        'renders only smallView if only smallView is provided',
        (WidgetTester tester) async {
          final testableWidget = makeTestableWidget(
            formFactor: formFactor,
            smallView: Container(
              key: smallViewKey,
            ),
          );

          await tester.pumpWidget(testableWidget);

          expect(find.byKey(smallViewKey), findsOneWidget);
          expect(find.byKey(mediumViewKey), findsNothing);
          expect(find.byKey(largeViewKey), findsNothing);
        },
      );

      testWidgets(
        'renders only smallView if only small and mediumViews are provided',
        (WidgetTester tester) async {
          final testableWidget = makeTestableWidget(
            formFactor: formFactor,
            mediumView: Container(
              key: mediumViewKey,
            ),
            largeView: Container(),
          );

          await tester.pumpWidget(testableWidget);

          expect(find.byKey(mediumViewKey), findsOneWidget);
          expect(find.byKey(smallViewKey), findsNothing);
          expect(find.byKey(largeViewKey), findsNothing);
        },
      );

      testWidgets(
        'renders only smallView if only small and largeViews are provided',
        (WidgetTester tester) async {
          final testableWidget = makeTestableWidget(
            formFactor: formFactor,
            smallView: Container(
              key: smallViewKey,
            ),
            largeView: Container(),
          );

          await tester.pumpWidget(testableWidget);

          expect(find.byKey(smallViewKey), findsOneWidget);
          expect(find.byKey(mediumViewKey), findsNothing);
          expect(find.byKey(largeViewKey), findsNothing);
        },
      );

      testWidgets(
        'renders only smallView if small, medium and largeViews are provided',
        (WidgetTester tester) async {
          final testableWidget = makeTestableWidget(
            formFactor: formFactor,
            smallView: Container(
              key: smallViewKey,
            ),
            mediumView: Container(),
            largeView: Container(),
          );

          await tester.pumpWidget(testableWidget);

          expect(find.byKey(smallViewKey), findsOneWidget);
          expect(find.byKey(mediumViewKey), findsNothing);
          expect(find.byKey(largeViewKey), findsNothing);
        },
      );

      testWidgets(
        'renders only mediumView if only mediumView is provided',
        (WidgetTester tester) async {
          final testableWidget = makeTestableWidget(
            formFactor: formFactor,
            mediumView: Container(
              key: mediumViewKey,
            ),
          );

          await tester.pumpWidget(testableWidget);

          expect(find.byKey(mediumViewKey), findsOneWidget);
          expect(find.byKey(smallViewKey), findsNothing);
          expect(find.byKey(largeViewKey), findsNothing);
        },
      );

      testWidgets(
        'renders only mediumView if only medium and largeViews are provided',
        (WidgetTester tester) async {
          final testableWidget = makeTestableWidget(
            formFactor: formFactor,
            mediumView: Container(
              key: mediumViewKey,
            ),
            largeView: Container(),
          );

          await tester.pumpWidget(testableWidget);

          expect(find.byKey(mediumViewKey), findsOneWidget);
          expect(find.byKey(smallViewKey), findsNothing);
          expect(find.byKey(largeViewKey), findsNothing);
        },
      );

      testWidgets(
        'renders only largeView if only largeView is provided',
        (WidgetTester tester) async {
          final testableWidget = makeTestableWidget(
            formFactor: formFactor,
            largeView: Container(
              key: largeViewKey,
            ),
          );

          await tester.pumpWidget(testableWidget);

          expect(find.byKey(largeViewKey), findsOneWidget);
          expect(find.byKey(smallViewKey), findsNothing);
          expect(find.byKey(mediumViewKey), findsNothing);
        },
      );
    });

    group('for medium form factors', () {
      const formFactor = FormFactor.medium;

      testWidgets(
        'renders only smallView if only smallView is provided',
        (WidgetTester tester) async {
          final testableWidget = makeTestableWidget(
            formFactor: formFactor,
            smallView: Container(
              key: smallViewKey,
            ),
          );

          await tester.pumpWidget(testableWidget);

          expect(find.byKey(smallViewKey), findsOneWidget);
          expect(find.byKey(mediumViewKey), findsNothing);
          expect(find.byKey(largeViewKey), findsNothing);
        },
      );

      testWidgets(
        'renders only mediumView if only small and mediumViews are provided',
        (WidgetTester tester) async {
          final testableWidget = makeTestableWidget(
            formFactor: formFactor,
            mediumView: Container(
              key: mediumViewKey,
            ),
            smallView: Container(),
          );

          await tester.pumpWidget(testableWidget);

          expect(find.byKey(mediumViewKey), findsOneWidget);
          expect(find.byKey(smallViewKey), findsNothing);
          expect(find.byKey(largeViewKey), findsNothing);
        },
      );

      testWidgets(
        'renders only largeView if only small and largeViews are provided',
        (WidgetTester tester) async {
          final testableWidget = makeTestableWidget(
            formFactor: formFactor,
            largeView: Container(
              key: largeViewKey,
            ),
            smallView: Container(),
          );

          await tester.pumpWidget(testableWidget);

          expect(find.byKey(largeViewKey), findsOneWidget);
          expect(find.byKey(smallViewKey), findsNothing);
          expect(find.byKey(mediumViewKey), findsNothing);
        },
      );

      testWidgets(
        'renders only mediumView if small, medium and largeViews are provided',
        (WidgetTester tester) async {
          final testableWidget = makeTestableWidget(
            formFactor: formFactor,
            mediumView: Container(
              key: mediumViewKey,
            ),
            smallView: Container(),
            largeView: Container(),
          );

          await tester.pumpWidget(testableWidget);

          expect(find.byKey(mediumViewKey), findsOneWidget);
          expect(find.byKey(smallViewKey), findsNothing);
          expect(find.byKey(largeViewKey), findsNothing);
        },
      );

      testWidgets(
        'renders only mediumView if only mediumView is provided',
        (WidgetTester tester) async {
          final testableWidget = makeTestableWidget(
            formFactor: formFactor,
            mediumView: Container(
              key: mediumViewKey,
            ),
          );

          await tester.pumpWidget(testableWidget);

          expect(find.byKey(mediumViewKey), findsOneWidget);
          expect(find.byKey(smallViewKey), findsNothing);
          expect(find.byKey(largeViewKey), findsNothing);
        },
      );

      testWidgets(
        'renders only mediumView if only medium and largeViews are provided',
        (WidgetTester tester) async {
          final testableWidget = makeTestableWidget(
            formFactor: formFactor,
            mediumView: Container(
              key: mediumViewKey,
            ),
            largeView: Container(),
          );

          await tester.pumpWidget(testableWidget);

          expect(find.byKey(mediumViewKey), findsOneWidget);
          expect(find.byKey(smallViewKey), findsNothing);
          expect(find.byKey(largeViewKey), findsNothing);
        },
      );

      testWidgets(
        'renders only largeView if only largeView is provided',
        (WidgetTester tester) async {
          final testableWidget = makeTestableWidget(
            formFactor: formFactor,
            largeView: Container(
              key: largeViewKey,
            ),
          );

          await tester.pumpWidget(testableWidget);

          expect(find.byKey(largeViewKey), findsOneWidget);
          expect(find.byKey(smallViewKey), findsNothing);
          expect(find.byKey(mediumViewKey), findsNothing);
        },
      );
    });

    group('for large form factors', () {
      const formFactor = FormFactor.large;

      testWidgets(
        'renders only smallView if only smallView is provided',
        (WidgetTester tester) async {
          final testableWidget = makeTestableWidget(
            formFactor: formFactor,
            smallView: Container(
              key: smallViewKey,
            ),
          );

          await tester.pumpWidget(testableWidget);

          expect(find.byKey(smallViewKey), findsOneWidget);
          expect(find.byKey(mediumViewKey), findsNothing);
          expect(find.byKey(largeViewKey), findsNothing);
        },
      );

      testWidgets(
        'renders only mediumView if only small and mediumViews are provided',
        (WidgetTester tester) async {
          final testableWidget = makeTestableWidget(
            formFactor: formFactor,
            mediumView: Container(
              key: mediumViewKey,
            ),
            smallView: Container(),
          );

          await tester.pumpWidget(testableWidget);

          expect(find.byKey(mediumViewKey), findsOneWidget);
          expect(find.byKey(smallViewKey), findsNothing);
          expect(find.byKey(largeViewKey), findsNothing);
        },
      );

      testWidgets(
        'renders only largeView if only small and largeViews are provided',
        (WidgetTester tester) async {
          final testableWidget = makeTestableWidget(
            formFactor: formFactor,
            largeView: Container(
              key: largeViewKey,
            ),
            smallView: Container(),
          );

          await tester.pumpWidget(testableWidget);

          expect(find.byKey(largeViewKey), findsOneWidget);
          expect(find.byKey(smallViewKey), findsNothing);
          expect(find.byKey(mediumViewKey), findsNothing);
        },
      );

      testWidgets(
        'renders only largeView if small, medium and largeViews are provided',
        (WidgetTester tester) async {
          final testableWidget = makeTestableWidget(
            formFactor: formFactor,
            largeView: Container(
              key: largeViewKey,
            ),
            smallView: Container(),
            mediumView: Container(),
          );

          await tester.pumpWidget(testableWidget);

          expect(find.byKey(largeViewKey), findsOneWidget);
          expect(find.byKey(smallViewKey), findsNothing);
          expect(find.byKey(mediumViewKey), findsNothing);
        },
      );

      testWidgets(
        'renders only mediumView if only mediumView is provided',
        (WidgetTester tester) async {
          final testableWidget = makeTestableWidget(
            formFactor: formFactor,
            mediumView: Container(
              key: mediumViewKey,
            ),
          );

          await tester.pumpWidget(testableWidget);

          expect(find.byKey(mediumViewKey), findsOneWidget);
          expect(find.byKey(smallViewKey), findsNothing);
          expect(find.byKey(largeViewKey), findsNothing);
        },
      );

      testWidgets(
        'renders only largeView if only medium and largeViews are provided',
        (WidgetTester tester) async {
          final testableWidget = makeTestableWidget(
            formFactor: formFactor,
            largeView: Container(
              key: largeViewKey,
            ),
            mediumView: Container(),
          );

          await tester.pumpWidget(testableWidget);

          expect(find.byKey(largeViewKey), findsOneWidget);
          expect(find.byKey(smallViewKey), findsNothing);
          expect(find.byKey(mediumViewKey), findsNothing);
        },
      );

      testWidgets(
        'renders only largeView if only largeView is provided',
        (WidgetTester tester) async {
          final testableWidget = makeTestableWidget(
            formFactor: formFactor,
            largeView: Container(
              key: largeViewKey,
            ),
          );

          await tester.pumpWidget(testableWidget);

          expect(find.byKey(largeViewKey), findsOneWidget);
          expect(find.byKey(smallViewKey), findsNothing);
          expect(find.byKey(mediumViewKey), findsNothing);
        },
      );
    });
  });
}
