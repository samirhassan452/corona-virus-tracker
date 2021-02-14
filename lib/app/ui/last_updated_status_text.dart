import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LastUpdatedDateFormatter {
  LastUpdatedDateFormatter({@required this.lastUpdated});
  final DateTime lastUpdated;

  String lastUpdatedStatusText() {
    if (lastUpdated != null) {
      // this is a factory constructor
      final formatter = DateFormat.yMEd().add_Hms();

      final formatted = formatter.format(lastUpdated);

      return 'Last updated: $formatted';
    }

    // handle if lastUpdated=null, then return empty string
    return '';
  }
}

class LastUpdatedStatusText extends StatelessWidget {
  const LastUpdatedStatusText({@required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }
}
