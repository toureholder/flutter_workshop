import 'package:flutter/material.dart';
import 'package:flutter_workshop/feature/home/home_bloc.dart';
import 'package:flutter_workshop/feature/login/login_bloc.dart';
import 'package:flutter_workshop/model/login/login_response.dart';
import 'package:flutter_workshop/util/http_event.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

class MockHomeBloc extends Mock implements HomeBloc {}

class MockLoginBloc extends Mock implements LoginBloc {}

class MockLoginResponseStream extends Mock
    implements Stream<HttpEvent<LoginResponse>> {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}
