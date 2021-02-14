import 'package:coronavirus_rest_api/app/repositories/data_repository.dart';
import 'package:coronavirus_rest_api/app/services/api.dart';
import 'package:coronavirus_rest_api/app/services/api_service.dart';
import 'package:coronavirus_rest_api/app/services/data_cache_service.dart';
import 'package:coronavirus_rest_api/app/ui/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// kind of errors we need to handle
/*
  1. Connectivity errors (offline means you don't have an internet)
  2. Server errors (API not working correctly)
  3. Parsing errors (missing/incorrecnt data in API response means you un-able to pass data from response correctly)

  // you should handle error and tell the user but not all of errors means :
  // access token: if access token has expired, user don't know what is access token, he just want an app that works
  // so you should handle if access token has expired without telling user anything
*/

// Data persistance: persist, show previuos data when :
/*
  1. device is offline
  2. server unavailable
  3. after quit or restarting app
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // by default the date formatted in Intl package is "en_US" locale which is MM/dd/yyyy
  // to change this, before running the app, we can change defaultLocale in Intl package
  // "en_GB" : United Kingdom which is dd/MM/yyyy
  Intl.defaultLocale = "en_GB";
  // and we should also make this to change change date formatting
  // and MyApp() will be mounted only after await call has returned
  await initializeDateFormatting();
  // by writing this code we
  // 1. avoid using FutureBuilder()
  // 2. make cachedData available synchronously by calling it before starting app and we design getData() method as sync cause we don't use Future
  // and this is a better way to acheive 1. Use sync api whenever possible  2. avoid FutureBuilder() if possible
  // because sync api is more efficient and easier to use
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(
    sharedPreferences: sharedPreferences,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({@required this.sharedPreferences});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<DataRepository>(
      create: (_) => DataRepository(
          apiService: APIService(API.sandbox()),
          dataCacheService: DataCacheService(
            // because we cannot write await here, so we create instance of sharedPreferences in main and through it to MyApp
            // to set it here
            sharedPreferences: sharedPreferences,
          )),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Corona Virus',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Color(0xFF101010),
          cardColor: Color(0xFF222222),
        ),
        home: Dashboard(),
      ),
    );
  }
}
