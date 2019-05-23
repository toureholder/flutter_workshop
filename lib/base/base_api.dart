import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:io';

import 'package:meta/meta.dart';

class BaseApi {
  final http.Client client;

  BaseApi({@required this.client});

  final String baseUrl = 'https://giv-api.herokuapp.com/';

  Future<http.Response> get(String url) =>
      client.get(url, headers: _getDefaultHeaders());

  Future<http.Response> post(String url, Map<String, dynamic> body) =>
      client.post(url, body: jsonEncode(body), headers: _getDefaultHeaders());

  Map<String, String> _getDefaultHeaders() =>
      {HttpHeaders.contentTypeHeader: 'application/json'};
}
