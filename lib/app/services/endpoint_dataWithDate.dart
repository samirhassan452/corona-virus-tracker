// we create this class cause we need to receive both data and date from the server

// last updated data from 2 sides :
// 1. from client  : when user refresh the data
// 2. from server : when last api updated time and we will get this info from the response data that we receive from api
// when request api from server, server response is 'data' & 'dateTime'

import 'package:flutter/foundation.dart';

class EndpointDataWithDate {
  // here value is required because we cannot have a valid endpoint data object if a value is not set
  // and for this reason we add other assertion to check if the value is not known
  // but the date is less important, so we don't add @required
  EndpointDataWithDate({@required this.value, this.date})
      : assert(value != null);

  final int value;
  final DateTime date;

  @override
  String toString() => 'date: $date, value: $value';
}
