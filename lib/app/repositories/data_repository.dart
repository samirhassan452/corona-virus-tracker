import 'package:coronavirus_rest_api/app/repositories/endpoints_data.dart';
import 'package:coronavirus_rest_api/app/services/api.dart';
import 'package:coronavirus_rest_api/app/services/api_service.dart';
import 'package:coronavirus_rest_api/app/services/data_cache_service.dart';
import 'package:coronavirus_rest_api/app/services/endpoint_dataWithDate.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class DataRepository {
  DataRepository({@required this.apiService, @required this.dataCacheService});
  final APIService apiService;
  final DataCacheService dataCacheService;

  String _accessToken;

  // only refresh access token when needed

  // get the data for given endpoint
  Future<EndpointDataWithDate> getEndpointData(Endpoint endpoint) async =>
      await _getDataRefreshingToken<EndpointDataWithDate>(
        onGetData: () => apiService.getEndpointData(
            accessToken: _accessToken, endpoint: endpoint),
      );

  // get the data from cache
  EndpointsData getAllEndpointsCachedData() => dataCacheService.getData();

  // get all data at once
  Future<EndpointsData> getAllEndpointsData() async {
    final endpointsData = await _getDataRefreshingToken<EndpointsData>(
      onGetData:
          _getAllEndpointData, // because onGetData() and _getAllEndpointData() both have no arguments, so we simplyfied
    );
    // save data to cache
    await dataCacheService.setData(endpointsData);

    return endpointsData;
  }

  // create generic method for all the common code that we can re-use
  // <T> for generic, once it will be 'int' and once it will be 'EndpointsData'
  Future<T> _getDataRefreshingToken<T>({Future<T> Function() onGetData}) async {
    // temporary code: to check if server response error but not 401, un-comment below line
    // throw 'error';

    // now we have a problem because this code will keep trying to use the same access token even after it has expired
    // so we need a way to detect when the token has expired and refresh it
    // to detect that, when call getEndpointData and response :
    // If we get 401 Unauthorized error, then access token has expired
    // so we will add below code inside try{}catch(){}
    try {
      if (_accessToken == null) {
        // we need to get a valid access token before we get endpoint data
        _accessToken = await apiService.getAccessToken();
      }
      return await onGetData();
    } on Response catch (response) {
      if (response.statusCode == 401) {
        _accessToken = await apiService.getAccessToken();
        return await onGetData();
      }
      // re-throw exception if not 401, means server has error
      // so we will handle this error in Dashboard
      rethrow;
    }
  }

  Future<EndpointsData> _getAllEndpointData() async {
    // this is un-useful code to wait each response of each request, we need to call all apis at once

    // final cases = await apiService.getEndpointData(
    //     accessToken: _accessToken, endpoint: Endpoint.cases);
    // final casesSuspected = await apiService.getEndpointData(
    //     accessToken: _accessToken, endpoint: Endpoint.casesSuspected);
    // final casesConfirmed = await apiService.getEndpointData(
    //     accessToken: _accessToken, endpoint: Endpoint.casesSuspected);
    // final deaths = await apiService.getEndpointData(
    //     accessToken: _accessToken, endpoint: Endpoint.deaths);
    // final recovered = await apiService.getEndpointData(
    //     accessToken: _accessToken, endpoint: Endpoint.recovered);

    // take a list of future to execute at parallel and return single future or response when all future list is completed
    // the below code all the requests run in parallel but the above code run sequential
    // and each request will wait other to complete
    // return will be  list of values from requests => [casesValue,casesSuspectedValue,.....]
    final values = await Future.wait(
      // instead of write 5 endpoints hard code,
      // [apiService.getEndpointData(accessToken: _accessToken, endpoint: Endpoint.cases),
      // apiService.getEndpointData(accessToken: _accessToken, endpoint: Endpoint.casesSuspected),
      // apiService.getEndpointData(accessToken: _accessToken, endpoint: Endpoint.casesConfirmed),
      // apiService.getEndpointData(accessToken: _accessToken, endpoint: Endpoint.deaths),
      // apiService.getEndpointData(accessToken: _accessToken, endpoint: Endpoint.recovered)]
      // we can create a loop of 5 endpoints
      List.generate(
        Endpoint.values.length,
        (index) => apiService.getEndpointData(
            accessToken: _accessToken, endpoint: Endpoint.values[index]),
      ),
    );

    return EndpointsData(
      // write values from list as ordered in enum or in Future.wait()
      values: {
        Endpoint.cases: values[0],
        Endpoint.casesSuspected: values[1],
        Endpoint.casesConfirmed: values[2],
        Endpoint.deaths: values[3],
        Endpoint.recovered: values[4],
      },
    );
  }
}
