# Flutter beginner's workshop

[![Build Status](https://travis-ci.com/toureh/flutter_workshop.svg?branch=master)](https://travis-ci.com/toureh/flutter_workshop)
[![codecov](https://codecov.io/gh/toureh/flutter_workshop/branch/master/graph/badge.svg)](https://codecov.io/gh/toureh/flutter_workshop)
[![Lint](https://img.shields.io/badge/style-pedantic-blue.svg)](https://github.com/dart-lang/pedantic)

This repository contains a sample app that I use to give workshops geared towards beginners to Flutter.

The commit history contains multiple ways of doing the same thing. For example, in one commit we manually spawn an isolate to do work in the background and in a later commit we use use Flutter's handy `compute` function to do the job. In one commit we manually parse and serialize json and in a later commit we do it with code generation.

I've made an effort to squash changes into cohesive commits that each represent a teachable building block in the app.


## Contains examples of:

* Basic widgets and building layouts
* Internationalization
* Navigation & routing
* Networking
* JSON parsing and serialization
* Moving work to a background isolate
* BLoC pattern
* Storing key-value data on disk
* Dependency injection with InheritedWidget
* Unit, widget and integration tests
* Configuring linting rules to implement the Effective Dart guidelines
* Continuous integration pipelines with Travis CI
* Uploading code coverage to Codecov


## Getting Started

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.io/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.io/docs/cookbook)

For help getting started with Flutter, view the 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.


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