import 'dart:convert';

import 'package:coronavirus_rest_api/app/services/endpoint_dataWithDate.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:coronavirus_rest_api/app/services/api.dart';

// this class is for make requests (request access token) and parse responses
class APIService {
  APIService(this.api);
  final API api;

  Future<String> getAccessToken() async {
    // we will make a http request to request access token
    final response = await http.post(
      api.tokenUri().toString(),
      headers: {'Authorization': 'Basic ${api.apiKey}'},
    );

    // extract access token from response(payload)
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final accessToken = data['access_token'];
      //print(accessToken);
      if (accessToken != null) {
        return accessToken;
      }
    }

    print(
        'Request ${api.tokenUri()} failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }

  // we update return type from int to EndpointDataWithDate
  // because we need to receive both data which is int and dateTime
  Future<EndpointDataWithDate> getEndpointData(
      {@required String accessToken, @required Endpoint endpoint}) async {
    final uri = api.endpointUri(endpoint);
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      /*
       data will be like this :
       '[
         {
           "cases"/"data" : int_value,
           "date" : datetime_value
         }
       ]'
      */
      // get the data from json
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        // get the first item in the data which is a List
        final Map<String, dynamic> endpointData = data[0];
        // convert the key of data
        final String responseJsonKey = _responseJsonKeys[endpoint];
        // get the result from extracted data
        final int value = endpointData[responseJsonKey];
        // get the dateTime from extracted data
        final String dateString = endpointData['date'];
        // convert above string to dateTime object
        // but parse method will throw exception if the input string cannot be parse
        // so we will use another method called tryParse because if input string cannot be parse, it will return null instead of error
        final date = DateTime.tryParse(dateString);
        if (value != null) {
          return EndpointDataWithDate(value: value, date: date);
        }
      }
    }

    // handle error if response fails
    print(
        'Request $uri failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }

  // create a new map to associate each end point to the json key that we will use to extract the data
  static Map<Endpoint, String> _responseJsonKeys = {
    Endpoint.cases: 'cases',
    Endpoint.casesSuspected: 'data',
    Endpoint.casesConfirmed: 'data',
    Endpoint.recovered: 'data',
    Endpoint.deaths: 'data',
  };
}
