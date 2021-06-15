flutter packages get \
&& flutter pub run build_runner build --delete-conflicting-outputs \
&& flutter analyze --no-pub --no-current-package lib/ test/ \
&& sh script/test_coverage.sh