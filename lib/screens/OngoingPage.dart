import 'package:flutter/material.dart';
import 'package:petra/helpers/DatabaseHelper.dart';
import 'package:petra/models/Result.dart';
import 'package:petra/screens/PredictPage.dart';
import 'package:petra/screens/ResultPage.dart';
import 'package:petra/widgets/Button.dart';

class OngoingPage extends StatefulWidget {
  @override
  _OngoingPageState createState() => _OngoingPageState();
}

class _OngoingPageState extends State<OngoingPage> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  String _error;

  void _navigateToResultPage(Result _result) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          result: _result,
          completeOption: true,
        ),
      ),
    );
  }

  void _navigateToPredictPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PredictPage(),
      ),
    );
  }

  void _fetchCurrentCycle() async {
    List<Result> _result = await this._databaseHelper.getOngoingCycles();
    if (_result.length > 0) {
      this._navigateToResultPage(_result[0]);
    } else {
      setState(() {
        _error = "You don't have any ongoing cycle.";
      });
    }
  }

  @override
  void initState() {
    _error = null;
    _fetchCurrentCycle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        child: Center(
          child: _error == null
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).backgroundColor),
                  backgroundColor: Theme.of(context).primaryColor,
                )
              : Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        this._error,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      PButton(
                        onPressed: this._navigateToPredictPage,
                        text: "Start Tracking",
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
