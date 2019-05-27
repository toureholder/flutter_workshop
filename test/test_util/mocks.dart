import 'package:flutter/material.dart';
import 'package:flutter_workshop/feature/login/login_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

class MockLoginBloc extends Mock implements LoginBloc {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}
