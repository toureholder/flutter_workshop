import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_workshop/custom/custom_app_bar.dart';
import 'package:flutter_workshop/feature/login/login_bloc.dart';
import 'package:provider/provider.dart';

import 'test_util/mocks.dart';
import 'test_util/test_util.dart';

void main() {
  Widget makeTestableWidget({String? title, List<Widget>? actions}) {
    return TestUtil.makeTestableWidget(
      dependencies: [
        Provider<LoginBloc>(create: (_) => MockLoginBloc()),
      ],
      subject: CustomAppBar(
        title: title,
        actions: actions,
      ),
    );
  }

  group('CusutomAppBar', () {
    testWidgets('is created', (WidgetTester tester) async {
      final widget = makeTestableWidget();

      await tester.pumpWidget(widget);

      expect(find.byType(CustomAppBar), findsOneWidget);
    });

    testWidgets('shows title', (WidgetTester tester) async {
      const title = 'Test Title';
      final widget = makeTestableWidget(title: title);

      await tester.pumpWidget(widget);

      final appBar = find.byType(CustomAppBar);
      final text = find.text(title);
      expect(find.descendant(of: appBar, matching: text), findsOneWidget);
    });

    testWidgets('always shows github button', (WidgetTester tester) async {
      final widget = makeTestableWidget();

      await tester.pumpWidget(widget);

      final appBar = find.byType(CustomAppBar);
      final githubButton = find.byKey(CustomAppBar.githubButtonKey);
      expect(
        find.descendant(of: appBar, matching: githubButton),
        findsOneWidget,
      );
    });

    testWidgets('adds actions to github button', (WidgetTester tester) async {
      const firstWidgetKey = Key('first_test_widget');
      const secondWidgetKey = Key('second_test_widget');

      final widget = makeTestableWidget(actions: const [
        Text('', key: firstWidgetKey),
        Text('', key: secondWidgetKey),
      ]);

      await tester.pumpWidget(widget);

      final appBar = find.byType(CustomAppBar);
      final githubButton = find.byKey(CustomAppBar.githubButtonKey);

      expect(
        find.descendant(of: appBar, matching: find.byKey(firstWidgetKey)),
        findsOneWidget,
      );

      expect(
        find.descendant(of: appBar, matching: find.byKey(secondWidgetKey)),
        findsOneWidget,
      );

      expect(
        find.descendant(of: appBar, matching: githubButton),
        findsOneWidget,
      );
    });

    // No need to over complicate things trying to spy on url_launcher methods.
    // Just tap the button to get test coverage.
    testWidgets('tapping github action doesn\'t blow anything up',
        (WidgetTester tester) async {
      final widget = makeTestableWidget();

      await tester.pumpWidget(widget);

      final githubButton = find.byKey(CustomAppBar.githubButtonKey);

      await tester.tap(githubButton);
    });
  });
}
