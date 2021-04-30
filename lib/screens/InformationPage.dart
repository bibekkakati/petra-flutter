import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

class InformationPage extends StatefulWidget {
  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  int _position = 1;

  final key = UniqueKey();

  void _doneLoading(String a) {
    setState(() {
      _position = 0;
    });
  }

  void _startLoading(String a) {
    setState(() {
      _position = 1;
    });
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: IndexedStack(
          index: this._position,
          children: [
            WebView(
              initialUrl: 'https://www.medicalnewstoday.com/articles/326906',
              key: key,
              onPageStarted: this._startLoading,
              onPageFinished: this._doneLoading,
            ),
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).backgroundColor),
                backgroundColor: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
