import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// this method return Future and this Future return when the dialog has been dismissed
Future<void> showAlertDialog({
  @required BuildContext context,
  @required String title,
  @required String content,
  @required String defaultActionText,
}) async {
  // use Cupertino package to customize code for IOS
  if (Platform.isIOS) {
    return await showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(defaultActionText),
          )
        ],
      ),
    );
  }

  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(defaultActionText),
        )
      ],
    ),
  );
}
