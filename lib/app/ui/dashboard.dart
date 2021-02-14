import 'dart:io';

import 'package:coronavirus_rest_api/app/repositories/data_repository.dart';
import 'package:coronavirus_rest_api/app/repositories/endpoints_data.dart';
import 'package:coronavirus_rest_api/app/services/api.dart';
import 'package:coronavirus_rest_api/app/ui/endpoint_card.dart';
import 'package:coronavirus_rest_api/app/ui/last_updated_status_text.dart';
import 'package:coronavirus_rest_api/app/ui/show_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  EndpointsData _endpointsData;

  void initState() {
    super.initState();
    final dataRepository = Provider.of<DataRepository>(context, listen: false);
    _endpointsData = dataRepository.getAllEndpointsCachedData();
    _updateData();
  }

  // we will call this method : 1. add a button with onPressed() callback  2. in Pull to refresh
  Future<void> _updateData() async {
    // when server is offline SocketException error appears
    // the problem appears inside APIService because there we call api, but we don't have internet
    // and we need to show msg error to use inside Dashboard
    // so we need to put try{}catch{}, and we will put this inside Dashboard because :
    /*
      we have something called CallStack: we will write example to understand
        void main(){
          print("hello from main");
          method();
        }
        void method1(){
          print("hello from method1");
          method2();
        }
        void method2(){
          print("hello from method2");
        }

        when run this code, it push main(), then method1() and finally method2()
        and while pop method2(), then method1(), and finally main()
        this is CallStack()

        so when error appears, it will show you the final error at final class
        and when skip, it pop from CallStack() and show the error before and so on
        until to reach the first error in first class

        so when server is offline: the first error will raise inside Dashboard()
        so we will put try()catch() here
    */
    try {
      final dataRepository =
          Provider.of<DataRepository>(context, listen: false);
      final endpointsData = await dataRepository.getAllEndpointsData();

      setState(() {
        _endpointsData = endpointsData;
      });
      // we don't need a variable, so we put _ to tell compiler that this is not important and ignore it
    } on SocketException catch (_) {
      // if we need to wait the dialog to be dismissed before we run some other code we can put await
      // but since we don't need to do anything after the dialog is dismissed, then await is not necessary
      showAlertDialog(
        context: context,
        title: 'Connection Error',
        content: 'Could not retrieve data. Please try again later.',
        defaultActionText: 'OK',
      );
      // generic server error handling if 4xx or 5xx but not 401
    } catch (err) {
      showAlertDialog(
        context: context,
        title: 'Unknown Error',
        content: 'Please contact support or try again later.',
        defaultActionText: 'OK',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = LastUpdatedDateFormatter(
      lastUpdated: _endpointsData != null
          // it might be raise an error in this line '_endpointsData.values[Endpoint.cases]': the getter 'date' was called on null
          // this error is familiar in many other languages called : 'null pointer exception'
          // and this happens because in first time of running app, we try to access values from cachedData
          // but it's still no data in cache yet, so after this app will run correctly, but we need to solve this first time exception
          //  to solve this we can use : conditional member access operator '?' before accessing the 'date'
          // if the expression before '?' is not null it will access 'date' property for the entire expression without throwing exception
          // this way might be useful when try to access method or variable from a class and it might be null
          // so use ?. instead of .
          ? _endpointsData.values[Endpoint.cases]?.date
          : null,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Coronavirus Tracker"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _updateData,
        child: ListView(
          children: [
            LastUpdatedStatusText(
              /*text: _endpointsData != null
                  // you can choose any endpoint because all of them have the same date
                  // and it's also safer to use the conditional member access operator '?' which is after date
                  // to deal with the fact that date might be null
                  // and add empty string at the end to ensure that we return empty string if we return null
                  ? _endpointsData.values[Endpoint.cases].date?.toString() ?? ''
                  : '',*/
              text: formatter.lastUpdatedStatusText(),
            ),
            for (var endpoint in Endpoint.values)
              EndpointCard(
                endpoint: endpoint,
                value: _endpointsData != null
                    // it might be raise an error in this line '_endpointsData.values[endpoint]': the getter 'date' was called on null
                    // so we will use conditional member access to solve this problem
                    ? _endpointsData.values[endpoint]?.value
                    : null,
              ),
          ],
        ),
      ),
    );
  }
}
