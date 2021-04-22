import 'package:flutter/material.dart';
import 'package:petra/screens/InformationPage.dart';
import 'package:petra/screens/OngoingPage.dart';
import 'package:petra/screens/PredictPage.dart';
import 'package:petra/screens/RecordsPage.dart';
import 'package:petra/widgets/Button.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
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
        child: SingleChildScrollView(
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
