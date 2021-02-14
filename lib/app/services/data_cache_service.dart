import 'package:coronavirus_rest_api/app/repositories/endpoints_data.dart';
import 'package:coronavirus_rest_api/app/services/api.dart';
import 'package:coronavirus_rest_api/app/services/endpoint_dataWithDate.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// here we will write all code for writing and reading data with SharedPreferences
class DataCacheService {
  DataCacheService({@required this.sharedPreferences});
  final SharedPreferences sharedPreferences;

  // make a key for value from endpoint
  static String endpointValueKey(Endpoint endpoint) => '$endpoint/value';
  // make a key for date from endpoint
  static String endpointDateKey(Endpoint endpoint) => '$endpoint/date';

  // getting data from shared preferences
  EndpointsData getData() {
    Map<Endpoint, EndpointDataWithDate> values = {};

    Endpoint.values.forEach((endpoint) {
      final value = sharedPreferences.getInt(endpointValueKey(endpoint));
      final dateString = sharedPreferences.getString(endpointDateKey(endpoint));

      if (value != null && dateString != null) {
        final date = DateTime.tryParse(dateString);
        values[endpoint] = EndpointDataWithDate(value: value, date: date);
      }
    });

    return EndpointsData(values: values);
  }

  // saving data to shared preferences
  Future<void> setData(EndpointsData endpointsData) async {
    endpointsData.values.forEach((endpoint, endpointData) async {
      // save/get data from sharedPreferences need async
      await sharedPreferences.setInt(
        endpointValueKey(endpoint),
        endpointData.value,
      );
      await sharedPreferences.setString(
        endpointDateKey(endpoint),
        endpointData.date.toIso8601String(),
      );
    });
  }
}
