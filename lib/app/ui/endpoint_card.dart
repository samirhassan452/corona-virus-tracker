import 'package:coronavirus_rest_api/app/services/api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// create class that represent each endpoint title,iconAssetName,color
class EndpointCardData {
  EndpointCardData({this.title, this.assetName, this.color});
  final String title;
  final String assetName;
  final Color color;
}

class EndpointCard extends StatelessWidget {
  const EndpointCard({this.endpoint, this.value});
  final Endpoint endpoint; // this is endpoint and we have 5 endpoints
  final int value; // this value which is number of each endpoint

  static Map<Endpoint, EndpointCardData> _cardsData = {
    Endpoint.cases: EndpointCardData(
      title: 'Cases',
      assetName: 'assets/icons/count.png',
      color: Color(0xFFFFF492),
    ),
    Endpoint.casesSuspected: EndpointCardData(
      title: 'Suspected cases',
      assetName: 'assets/icons/suspect.png',
      color: Color(0xFFEEDA28),
    ),
    Endpoint.casesConfirmed: EndpointCardData(
      title: 'Confirmed cases',
      assetName: 'assets/icons/fever.png',
      color: Color(0xFFE99600),
    ),
    Endpoint.deaths: EndpointCardData(
      title: 'Deaths',
      assetName: 'assets/icons/death.png',
      color: Color(0xFFE40000),
    ),
    Endpoint.recovered: EndpointCardData(
      title: 'Recovered',
      assetName: 'assets/icons/patient.png',
      color: Color(0xFF70A901),
    ),
  };

  // format thousands number means add comma after every three digits
  // e.g. 000,000,000 or 00,000,000 or 0,000,000
  String get formattedValue {
    if (value == null) {
      return '';
    }

    return NumberFormat('#,###,###,###').format(value);
  }

  @override
  Widget build(BuildContext context) {
    final cardData = _cardsData[endpoint];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cardData.title,
                style: Theme.of(context).textTheme.headline5.copyWith(
                      color: cardData.color,
                    ),
              ),
              SizedBox(height: 4.0),
              // ensure that all children in Row have the same height
              // because Row height is determined by the height of the tallest child (image widget)
              // and Images have slightly different heights
              SizedBox(
                // fixed height for all children
                height: 52.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // ensure that image and value are centered vertically
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      cardData.assetName,
                      color: cardData.color,
                    ),
                    Text(
                      //value != null ? value.toString() : '',
                      formattedValue,
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          color: cardData.color, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
