import 'package:flutter/material.dart';

void showMessageBar(BuildContext context, String message,
    {bool error, Function action, String actionLabel}) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor:
        error == null || error == false ? Colors.green : Colors.red,
    duration: Duration(seconds: 4),
    action: action != null && actionLabel != null
        ? SnackBarAction(
            label: actionLabel,
            onPressed: action,
            textColor: Color(0xFFffffff),
          )
        : null,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
  return;
}
