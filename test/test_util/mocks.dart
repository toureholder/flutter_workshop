import 'dart:async';

import 'package:flutter_workshop/feature/home/home_bloc.dart';
import 'package:flutter_workshop/feature/login/login_bloc.dart';
import 'package:flutter_workshop/model/donation/donation.dart';
import 'package:flutter_workshop/model/login/login_response.dart';
import 'package:flutter_workshop/service/disk_storage_provider.dart';
import 'package:flutter_workshop/service/session_provider.dart';
import 'package:flutter_workshop/util/http_event.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockClient extends Mock implements http.Client {}

class MockHomeBloc extends Mock implements HomeBloc {}

class MockLoginBloc extends Mock implements LoginBloc {}

class MockDonationListStream extends Mock implements Stream<List<Donation>> {}

class MockLoginResponseStream extends Mock
    implements Stream<HttpEvent<LoginResponse>> {}

class MockSessionProvider extends Mock implements SessionProvider {}

class MockDiskStorageProvider extends Mock implements DiskStorageProvider {}
