import 'package:flutter/material.dart';
import 'package:petra/helpers/DatabaseHelper.dart';
import 'package:petra/helpers/LocalNotification.dart';
import 'package:petra/helpers/LocalStorage.dart';
import 'package:petra/models/Result.dart';
import 'package:petra/screens/InformationPage.dart';
import 'package:petra/screens/NameInputPage.dart';
import 'package:petra/screens/OngoingPage.dart';
import 'package:petra/screens/PredictPage.dart';
import 'package:petra/screens/RecordsPage.dart';
import 'package:petra/widgets/Button.dart';
import 'package:uuid/uuid.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  LocalNotification _localNotification = LocalNotification();
  LocalStorage _localStorage = LocalStorage();
  Uuid uuid = Uuid();

  bool _loading;

  void _navigateToPredict() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PredictPage()));
  }

  void _navigateToOngoing() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => OngoingPage()));
  }

  void _navigateToRecords() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RecordsPage()));
  }

  void _navigateToInformation() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => InformationPage()));
  }

  void _navigateToNameInput() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => NameInputPage()));
  }

  void _startCycle(Result _result) {
    DateTime lastPeriod,
        nextPeriod,
        follicularPhase,
        ovulationPhase,
        lutealPhase;
    int cycleLength = _result.cycleLength;
    lastPeriod = new DateTime.now();
    nextPeriod = lastPeriod.add(Duration(days: cycleLength));
    follicularPhase = lastPeriod.add(Duration(days: 1));
    ovulationPhase = lastPeriod.add(Duration(days: (cycleLength / 2).floor()));
    lutealPhase = lastPeriod.add(Duration(days: (cycleLength / 2).floor() + 2));
    Result result = Result(null, cycleLength, lastPeriod, nextPeriod,
        follicularPhase, ovulationPhase, lutealPhase);
    this._trackCycle(result);
  }

  void _trackCycle(Result result) async {
    result.id = uuid.v1();
    bool done = await _databaseHelper.insertCycle(result);
    if (done == true) {
      String name = await this._localStorage.get("name");
      this._localNotification.scheduleNotification(
            "Hey, $name",
            "Your period is near 🌸",
            result.nextPeriod,
          );
    }
  }

  void _syncRecords() async {
    List<Result> result = await this._databaseHelper.getOngoingCycles();
    if (result.length > 0) {
      if (result[0].nextPeriod.isBefore(DateTime.now())) {
        await this._databaseHelper.moveCycle(result[0]);
        this._startCycle(result[0]);
      }
    }
  }

  void _isFirstTime() async {
    String name = await this._localStorage.get("name");
    if (name == null) {
      this._navigateToNameInput();
    } else {
      setState(() {
        _loading = false;
      });
      this._syncRecords();
    }
  }

  @override
  void initState() {
    _loading = true;
    this._isFirstTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screenRoutes = [
      PButton(
        text: "Predict",
        onPressed: _navigateToPredict,
      ),
      PButton(
        text: "Ongoing",
        onPressed: _navigateToOngoing,
      ),
      PButton(
        text: "Records",
        onPressed: _navigateToRecords,
      ),
      OButton(
        text: "Information",
        onPressed: _navigateToInformation,
      ),
    ];
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: this._loading == true
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).backgroundColor),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/logo.jpg",
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 40),
                        width: 200,
                        height: 240,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: screenRoutes,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
