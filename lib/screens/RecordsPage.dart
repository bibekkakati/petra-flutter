import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:petra/helpers/DatabaseHelper.dart';
import 'package:petra/models/Result.dart';
import 'package:petra/screens/ResultPage.dart';
import 'package:petra/widgets/BottomModal.dart';
import 'package:petra/widgets/Button.dart';
import 'package:petra/widgets/MessageBar.dart';

class RecordsPage extends StatefulWidget {
  @override
  _RecordsPageState createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  DateTime _todaysDate;
  bool _loading;
  List<Result> _recordCycles;

  void _fetchRecordCycles() async {
    List<Result> list = await _databaseHelper.getRecordCycles();
    if (list != null) {
      this._recordCycles = [];
      setState(() {
        this._recordCycles = list;
        _loading = false;
      });
    }
  }

  void _confirmDelete(Result cycle) {
    if (cycle != null) {
      showBottomModal(
        context,
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text("Confirm Deletion?"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PButton(
                    text: "Delete",
                    onPressed: () => this._delete(cycle),
                  ),
                  OButton(
                    text: "Cancel",
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

  void _delete(Result cycle) async {
    Navigator.pop(context);
    bool done = await _databaseHelper.deleteRecord(cycle);
    if (done == true) {
      showMessageBar(context, "Deleted successfully");
      setState(() {
        _loading = true;
      });
      this._fetchRecordCycles();
    } else {
      showMessageBar(context, "Deletion failed!", error: true);
    }
  }

  void _navigateToResultPage(Result result) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ResultPage(result: result)));
  }

  @override
  void initState() {
    super.initState();
    this._loading = true;
    this._todaysDate = DateTime.now();
    this._recordCycles = [];
    this._fetchRecordCycles();
  }

  @override
  Widget build(BuildContext context) {
    GestureDetector cycleCard(Result cycle) {
      String periodDay = min(
              this._todaysDate.difference(cycle.lastPeriod).inDays + 2,
              cycle.cycleLength)
          .toString();
      return GestureDetector(
        onTap: () => this._navigateToResultPage(cycle),
        onLongPress: () => this._confirmDelete(cycle),
        child: Container(
          margin: EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 8.0),
          child: Card(
            elevation: 10.0,
            shadowColor: Theme.of(context).primaryColor.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🌸 ' + cycle.title,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).textTheme.bodyText1.color,
                        ),
                      ),
                      Text(
                        "Period Date: " +
                            DateFormat.MMMMd().format(cycle.nextPeriod),
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).textTheme.bodyText1.color,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: Text(
                      "Day " + periodDay,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor.withOpacity(0.4),
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Container getContent() {
      if (this._recordCycles.length == 0) {
        return Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.hourglass_empty,
                    color: Theme.of(context).textTheme.bodyText1.color,
                    size: 28.0,
                  ),
                ),
                Text(
                  "You don't have any past cycle!",
                  style: Theme.of(context).textTheme.bodyText1,
                )
              ],
            ),
          ),
        );
      }
      return Container(
        child: ListView.builder(
          itemCount: this._recordCycles.length,
          itemBuilder: (context, index) {
            return cycleCard(this._recordCycles[index]);
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Past Cycles",
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: this._loading == true
            ? Center(
                child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).backgroundColor),
                backgroundColor: Theme.of(context).primaryColor,
              ))
            : getContent(),
      ),
    );
  }
}
