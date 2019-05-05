import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:io';

class BaseApi {
  final String baseUrl = 'https://giv-api.herokuapp.com/';

  Future<http.Response> get(String url) =>
      http.get(url, headers: _getDefaultHeaders());

  Future<http.Response> post(String url, Map<String, dynamic> body) =>
      http.post(url, body: jsonEncode(body), headers: _getDefaultHeaders());

  Map<String, String> _getDefaultHeaders() =>
      {HttpHeaders.contentTypeHeader: 'application/json'};
}
