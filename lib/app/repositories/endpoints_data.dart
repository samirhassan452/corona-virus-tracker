import 'package:coronavirus_rest_api/app/services/api.dart';
import 'package:coronavirus_rest_api/app/services/endpoint_dataWithDate.dart';
import 'package:flutter/foundation.dart';

class EndpointsData {
  // instead of creating each value like this
  // final int cases;
  // final int casesSuspected;
  // final int casesConfirmed;
  // final int deaths;
  // final int recovered;

  // we can create Map of endpoint as key and value
  EndpointsData({@required this.values});
  final Map<Endpoint, EndpointDataWithDate> values;

  // make endpoints easier to query when needed
  EndpointDataWithDate get cases => values[Endpoint.cases];
  EndpointDataWithDate get casesSuspected => values[Endpoint.casesSuspected];
  EndpointDataWithDate get casesConfirmed => values[Endpoint.casesConfirmed];
  EndpointDataWithDate get deaths => values[Endpoint.deaths];
  EndpointDataWithDate get recovered => values[Endpoint.recovered];

  @override
  String toString() =>
      'cases: $cases, suspected: $casesSuspected, confirmed: $casesConfirmed, deaths: $deaths, recovered: $recovered';
}
