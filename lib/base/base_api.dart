import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class BaseApi {
  BaseApi({@required this.client});

  final http.Client client;

  final String baseUrl = 'https://giv-api.herokuapp.com/';

  Future<http.Response> get(String url) =>
      client.get(Uri.parse(url), headers: _getDefaultHeaders());

  Future<http.Response> post(String url, Map<String, dynamic> body) =>
      client.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: _getDefaultHeaders(),
      );

  Map<String, String> _getDefaultHeaders() =>
      {HttpHeaders.contentTypeHeader: 'application/json'};
}
