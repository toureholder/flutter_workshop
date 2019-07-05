import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter_workshop/base/base_api.dart';
import 'package:flutter_workshop/model/donation/donation.dart';
import 'package:flutter_workshop/model/donation/donation_api_response.dart';
import 'package:flutter_workshop/util/respondable_message.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class DonationApi extends BaseApi {
  DonationApi({@required http.Client client}) : super(client: client);

  Future<List<Donation>> getDonations() async {
    final String url = '${baseUrl}listings/categories/33';
    final http.Response response = await get(url);
    final Map<String, dynamic> json = jsonDecode(response.body);
    final dto =
        await computeInIsolate<DonationApiResponse>(parseDonations, json);
    return dto.donations;
  }
}

void parseDonations(SendPort sendPort) async {
  final port = ReceivePort();
  sendPort.send(port.sendPort);

  await for (var message in port) {
    if (message is RespondableMessage) {
      final json = message.data;
      final result = DonationApiResponse.fromJson(json);
      message.sendPort.send(result);
    }

    port.close();
  }
}
