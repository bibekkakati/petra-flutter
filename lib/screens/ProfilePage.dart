import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:petra/helpers/LocalStorage.dart';
import 'package:petra/screens/ProfileInputPage.dart';
import 'package:petra/widgets/Button.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _title;
  num _weight;
  num _height;
  String _bmi;

  LocalStorage _localStorage = LocalStorage();

  void _navigateToNameInput() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProfileInputPage()));
  }

  void _populateData() async {
    String title = await this._localStorage.get("name");
    num weight = num.tryParse(await this._localStorage.get("weight"));
    num height = num.tryParse(await this._localStorage.get("height"));
    String bmi;
    if (weight != null && height != null && height > 0 && weight > 0) {
      bmi = (weight / (height * height)).toStringAsFixed(2);
    }
    setState(() {
      _title = title;
      _weight = weight;
      _height = height;
      _bmi = bmi;
    });
  }

  @override
  void initState() {
    this._populateData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Center(
          child: Card(
            child: Container(
              height: 260,
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Hello, $_title",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    "Weight: $_weight Kg",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).textTheme.bodyText1.color,
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    "Height: $_height m",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).textTheme.bodyText1.color,
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    "BMI: $_bmi",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).textTheme.bodyText1.color,
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  OButton(
                    text: "Edit Profile",
                    onPressed: _navigateToNameInput,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
