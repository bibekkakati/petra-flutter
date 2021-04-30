import 'package:flutter/material.dart';
import 'package:petra/helpers/LocalStorage.dart';
import 'package:petra/screens/HomePage.dart';
import 'package:petra/widgets/Button.dart';
import 'package:petra/widgets/MessageBar.dart';

class NameInputPage extends StatefulWidget {
  @override
  _NameInputPageState createState() => _NameInputPageState();
}

class _NameInputPageState extends State<NameInputPage> {
  String _title;

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
    } else {
      this._dismissKeyboard();
      await this._localStorage.set("name", this._title);
      this._navigateToHomePage();
    }
  }

  void _onTitleChange(String value) {
    if (value.length <= 20) {
      this._title = value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
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
              PButton(
                text: "Continue",
                onPressed: this._saveCycle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
