# Flutter beginner's workshop

[![Build Status](https://travis-ci.com/toureholder/flutter_workshop.svg?branch=master)](https://travis-ci.com/toureholder/flutter_workshop)
[![codecov](https://codecov.io/gh/toureholder/flutter_workshop/branch/master/graph/badge.svg?token=XOk497Byof)](https://codecov.io/gh/toureholder/flutter_workshop)
[![Lint](https://img.shields.io/badge/style-pedantic-blue.svg)](https://github.com/dart-lang/pedantic)
[![Demo](https://img.shields.io/badge/live-demo-orange.svg)](http://flutter-workshop.surge.sh)

This repository contains a sample app that I use to give workshops geared towards beginners to Flutter

## Contains examples of:
* [Building adaptive/responsive layouts with `adaptive_layout`](https://github.com/toureholder/flutter_workshop/blob/master/lib/feature/login/login.dart#L46)
* [Internationalization](https://github.com/toureholder/flutter_workshop/commit/e593145c0adb89e9756a1218207db3d2e0f8cedc)
* [Improving accessibility with Semantics](https://github.com/toureholder/flutter_workshop/commit/0860dd7a79788f9b340361b922688a3aa74b5720)
* [Navigation by creating a new route and pushing it to the Navigator](https://github.com/toureholder/flutter_workshop/commit/4e93b50ede90788a3a4f9ce489c29543139ecedc)
* [Navigation with named routes](https://github.com/toureholder/flutter_workshop/commit/94c77b94bbc01d7d9c53cee7b6b517b06be8fd73)
* [Networking](https://github.com/toureholder/flutter_workshop/commit/be6a4c42a115dff214ad1060ba1b87fe68672b08)
* Manual JSON [parsing](https://github.com/toureholder/flutter_workshop/commit/cd046f7a80a23a0251c9d0ae7df100fb9e84f6bb) and [serialization](https://github.com/toureholder/flutter_workshop/commit/966b3ecf40a085e3a44b360d1edcb022932a5355)
* [Spawning a background isolate manually](https://github.com/toureholder/flutter_workshop/commit/c9c237c79c9f643b0d4eac085640085b48a87641) and [with `compute`](https://github.com/toureholder/flutter_workshop/commit/f42e14c3d396f01f1cb34c295ffd15da0e4f5294)
* [BLoC pattern](https://github.com/toureholder/flutter_workshop/commit/4ab67f6c3b44d919b5a97edd8431e057ac080b9f) with [StreamBuilder](https://github.com/toureholder/flutter_workshop/blob/master/lib/feature/home/home.dart#L113)
* [Storing key-value data on disk](https://github.com/toureholder/flutter_workshop/blob/master/lib/service/shared_preferences_storage.dart)
* Dependency injection with [InheritedWidget](https://github.com/toureholder/flutter_workshop/commit/80e73245529a2b99be06daace8dc0f39a9e3e64c) and with [provider](https://github.com/toureholder/flutter_workshop/blob/master/lib/base/dependencies.dart)
* [Unit, widget](https://github.com/toureholder/flutter_workshop/tree/master/test) and [integration](https://github.com/toureholder/flutter_workshop/blob/master/test_driver/app_test.dart) tests
* [Configuring linting rules to implement the Effective Dart guidelines](https://github.com/toureholder/flutter_workshop/commit/ccf6b86b02b9b80fa5316a2c212af9438ead7366)
* [Continuous integration pipelines with Travis CI](https://github.com/toureholder/flutter_workshop/blob/master/.travis.yml)
* [Uploading code coverage to Codecov](https://github.com/toureholder/flutter_workshop/commit/38f87f6ce4cdaa6f5a1efb801306ca5148d49392)
* [Migrating to Null-safety (mostly done by the migration tool)](https://github.com/toureholder/flutter_workshop/commit/1ec21dd0109b157b5c3af81ec22de8b5c007a191)
* [Easily overriding `==` and `hashCode` with `equatable`](./lib/model/user/user.dart)
* [Using custom icons generated with FlutterIcon](https://github.com/toureholder/flutter_workshop/commit/e99a572326c910eef73b74d5a400164c1c28c853)

The commit history contains multiple ways of doing the same thing. Some examples are:
- In one commit we manually spawn an isolate to do work in the background and in a later commit we use use Flutter's `compute` function to do the job.
- In one commit we manually parse and serialize JSON and in a later commit we do it with code generation.
- Dependency injection is done with with InheritedWidget and then with [provider](https://github.com/rrousselGit/provider).
- Navigation is done by creating a new route and pushing it to the Navigator then we used named routes.

I've made an effort to squash changes into atomic commits that each represent a teachable building block in the app.

## Demo
Find a live demo of the app at http://flutter-workshop.surge.sh
  
## Running the app

```sh
flutter doctor # Verify that your dev environment is set up correctly
flutter pub run build_runner build # Generate serialization boilerplate code
flutter run # Run the app on an attached device
```

## Running the tests
```sh
flutter analyze --no-pub --no-current-package lib/ test/ # Static analysis
flutter test # Tests
```

## Test the CI pipeline on your machine
```sh
flutter packages get &&
flutter pub run build_runner build --delete-conflicting-outputs &&
flutter analyze --no-pub --no-current-package lib/ test/ &&
flutter test
```

## Gitmojis
:bulb: `:bulb:` when adding a new functionality

:repeat: `:repeat:` when making changes to an existing functionality

:cool: `:cool:` when refactoring

:bug: `:bug:` when fixing a problem

:green_heart: `:green_heart:` when fixing continuous integration / tech health issues

:white_check_mark: `:white_check_mark:` when adding tests

:blue_book: `:blue_book:` when writing documentation

:arrow_up: `:arrow_up:` when upgrading dependencies

:arrow_down: `:arrow_down:` when downgrading dependencies

:lock: `:lock:` when dealing with security

:racehorse: `:racehorse:` when improving performance

:non-potable_water: `:non-potable_water:` when resolving memory leaks

:fire: `:fire:` when removing code or files

:minidisc: `:minidisc:` when doing data backup

:grimacing: `:grimacing:` for that "temporary" workaround