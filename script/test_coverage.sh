flutter test --coverage --coverage-path=coverage/lcov_before_filter.info \
&& lcov --remove coverage/lcov_before_filter.info -o coverage/lcov.info '**/*.g.dart' \
&& genhtml coverage/lcov.info -o coverage/