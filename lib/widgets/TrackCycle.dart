import 'package:flutter/material.dart';
import 'package:petra/helpers/DatabaseHelper.dart';
import 'package:petra/helpers/LocalNotification.dart';
import 'package:petra/models/Result.dart';
import 'package:petra/widgets/Button.dart';
import 'package:uuid/uuid.dart';

class TrackCycle extends StatefulWidget {
  final Result result;

  TrackCycle({Key key, @required this.result}) : super(key: key);

  @override
  _TrackCycleState createState() => _TrackCycleState();
}

class _TrackCycleState extends State<TrackCycle> {
  Uuid uuid = Uuid();
  DatabaseHelper _databaseHelper = DatabaseHelper();
  LocalNotification _localNotification = LocalNotification();
  Result _result;
  String _title;
  String _error;

  void _saveCycle() async {
    if (this._title != null) {
      this._title = this._title.trim();
    }
    if (this._title == null || this._title == "" || this._title == " ") {
      setState(() {
        _error = 'Please select a name.';
      });
    } else {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      this._result.id = uuid.v1();
      this._result.title = this._title;
      bool done = await _databaseHelper.insertCycle(this._result);
      this._localNotification.scheduleNotification(
            "Hey, " + this._title,
            "Your period is near 🌸",
            this._result.nextPeriod,
          );
      Navigator.pop(context, done);
    }
  }

  void _onTitleChange(String value) {
    if (value.length <= 20) {
      this._title = value;
    }
    if (_error != "") {
      setState(() {
        _error = "";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _result = widget.result;
    _error = "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 30.0,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              color: Theme.of(context).backgroundColor,
            ),
            child: Center(
              child: Text(
                this._error,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 15.0, right: 15.0),
            child: TextField(
              keyboardType: TextInputType.text,
              maxLength: 20,
              maxLines: 1,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Name Your Period Cycle',
                labelStyle: Theme.of(context).textTheme.bodyText1,
                alignLabelWithHint: true,
              ),
              onChanged: this._onTitleChange,
            ),
          ),
          PButton(
            text: "Done",
            onPressed: this._saveCycle,
          ),
        ],
      ),
    );
  }
}
