import 'package:coronavirus_rest_api/app/services/api_keys.dart';
import 'package:flutter/foundation.dart';

// define every case to make a request
enum Endpoint { cases, casesSuspected, casesConfirmed, deaths, recovered }

// we can store all the urls in APIService class itself
// but it's better to have seperate API class to have urls
// because we can create seperate instances of the API class for sandbox/production
// so that APIService class doesn't have to worry about which environment we are using sandbox or production
// make request with http package
class API {
  API({@required this.apiKey});

  final String apiKey;

  // create factory constructor that will be helper when we create instances if this class
  factory API.sandbox() => API(apiKey: APIKeys.ncovSandboxKey);

  static final String host = "ncov2019-admin.firebaseapp.com";

  // Uri(Url) to access token
  // Uri syntax : [http|https]://[host]/[port]/[path]?[queryParameters]
  Uri tokenUri() => Uri(
        scheme: "https",
        host: host,
        path: "token",
      );

  // make a uri of endpoint request
  Uri endpointUri(Endpoint endpoint) => Uri(
        scheme: "https",
        host: host,
        path: _paths[endpoint],
      );

  // define map to take every case from enum and convert it to request
  static Map<Endpoint, String> _paths = {
    Endpoint.cases: 'cases',
    Endpoint.casesSuspected: 'casesSuspected',
    Endpoint.casesConfirmed: 'casesConfirmed',
    Endpoint.recovered: 'recovered',
    Endpoint.deaths: 'deaths',
  };
}
