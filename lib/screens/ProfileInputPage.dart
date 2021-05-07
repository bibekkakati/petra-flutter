import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petra/helpers/LocalStorage.dart';
import 'package:petra/screens/HomePage.dart';
import 'package:petra/widgets/Button.dart';
import 'package:petra/widgets/MessageBar.dart';

class ProfileInputPage extends StatefulWidget {
  @override
  _ProfileInputPageState createState() => _ProfileInputPageState();
}

class _ProfileInputPageState extends State<ProfileInputPage> {
  String _title;
  num _weight;
  num _height;

  LocalStorage _localStorage = LocalStorage();

  void _dismissKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _navigateToHomePage() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Homepage()));
  }

  void _saveCycle() async {
    if (this._title != null) {
      this._title = this._title.trim();
    }
    if (this._title == null || this._title == "" || this._title == " ") {
      showMessageBar(context, "Your first name is required.", error: true);
    } else if (this._weight == null ||
        this._weight < 20 ||
        this._weight > 200) {
      showMessageBar(context, "Weight should be in range of 20 to 200 Kg.",
          error: true);
    } else if (this._height == null ||
        this._height < 0.5 ||
        this._height > 9.9) {
      showMessageBar(context, "Height should be in range of 0.5 to 9.9 meter.",
          error: true);
    } else {
      this._dismissKeyboard();
      await this._localStorage.set("name", this._title);
      await this._localStorage.set("weight", this._weight.toString());
      await this._localStorage.set("height", this._height.toString());
      this._navigateToHomePage();
    }
  }

  void _onTitleChange(String value) {
    if (value.length <= 20) {
      this._title = value;
    }
  }

  void _onWeightChange(String value) {
    this._weight = num.tryParse(value);
  }

  void _onHeightChange(String value) {
    this._height = num.tryParse(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.only(left: 40.0, right: 40.0),
            height: 340,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  keyboardType: TextInputType.text,
                  maxLength: 10,
                  maxLines: 1,
                  autofocus: false,
                  decoration: InputDecoration(
                    labelText: 'Your first name',
                    labelStyle: Theme.of(context).textTheme.bodyText1,
                    alignLabelWithHint: true,
                  ),
                  onChanged: this._onTitleChange,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 3,
                  maxLines: 1,
                  autofocus: false,
                  decoration: InputDecoration(
                    labelText: 'Your weight (in kg)',
                    labelStyle: Theme.of(context).textTheme.bodyText1,
                    alignLabelWithHint: true,
                  ),
                  onChanged: this._onWeightChange,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  maxLines: 1,
                  autofocus: false,
                  decoration: InputDecoration(
                    labelText: 'Your height (in meter)',
                    labelStyle: Theme.of(context).textTheme.bodyText1,
                    alignLabelWithHint: true,
                  ),
                  onChanged: this._onHeightChange,
                ),
                PButton(
                  text: "Save",
                  onPressed: this._saveCycle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
