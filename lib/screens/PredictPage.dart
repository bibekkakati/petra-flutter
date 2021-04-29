import 'package:flutter/material.dart';
import 'package:petra/models/Result.dart';
import 'package:petra/screens/ResultPage.dart';
import 'package:petra/widgets/Button.dart';
import 'package:petra/widgets/CyclePicker.dart';
import 'package:petra/widgets/MessageBar.dart';
import 'package:table_calendar/table_calendar.dart';

class PredictPage extends StatefulWidget {
  @override
  _PredictPageState createState() => _PredictPageState();
}

class _PredictPageState extends State<PredictPage> {
  int _cycleLength;
  DateTime _focusedDay;
  DateTime _lastDay;
  DateTime _firstDay;
  DateTime _selectedDay;

  void _onCycleLengthSelect(String value) {
    this._cycleLength = int.parse(value);
  }

  void _onDaySelect(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  void _navigateToResultPage(Result result) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ResultPage(
          result: result,
        ),
      ),
    );
  }

  void _predictCycle() {
    if (this._cycleLength >= 11 &&
        this._cycleLength <= 45 &&
        this._selectedDay != null) {
      DateTime lastPeriod,
          nextPeriod,
          follicularPhase,
          ovulationPhase,
          lutealPhase;
      int cycleLength = this._cycleLength;
      lastPeriod = this._selectedDay;
      nextPeriod = lastPeriod.add(Duration(days: cycleLength));
      follicularPhase = lastPeriod;
      ovulationPhase =
          lastPeriod.add(Duration(days: (cycleLength / 2).floor()));
      lutealPhase =
          lastPeriod.add(Duration(days: (cycleLength / 2).floor() + 2));
      Result result = Result(null, cycleLength, lastPeriod, nextPeriod,
          follicularPhase, ovulationPhase, lutealPhase);
      this._navigateToResultPage(result);
    } else {
      showMessageBar(context, "Please select your last period date.",
          error: true);
    }
  }

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _lastDay = DateTime.now();
    _firstDay = DateTime.now().subtract(Duration(days: 45));
    _cycleLength = 28;
  }

  @override
  Widget build(BuildContext context) {
    TableCalendar tableCalendar = TableCalendar(
      firstDay: this._firstDay,
      lastDay: this._lastDay,
      focusedDay: this._focusedDay,
      calendarFormat: CalendarFormat.month,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      rowHeight: 45.0,
      calendarStyle: CalendarStyle(
        isTodayHighlighted: false,
        selectedDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).primaryColor,
        ),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: Theme.of(context).textTheme.bodyText1,
        weekendStyle: Theme.of(context).textTheme.bodyText1,
      ),
      availableGestures: AvailableGestures.horizontalSwipe,
      selectedDayPredicate: (day) => isSameDay(this._selectedDay, day),
      onDaySelected: this._onDaySelect,
      onPageChanged: (focusedDay) {
        this._focusedDay = focusedDay;
      },
    );

    Container cycleLengthPicker() => Container(
          margin: EdgeInsets.only(
            top: 30.0,
            bottom: 15.0,
            left: 15.0,
            right: 15.0,
          ),
          height: 120.0,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 10.0,
            shadowColor: Theme.of(context).primaryColor.withOpacity(0.2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Whats your usual cycle length?",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                CyclePicker(onSelect: _onCycleLengthSelect)
              ],
            ),
          ),
        );

    Container datePicker() => Container(
          margin: EdgeInsets.only(
            top: 0.0,
            bottom: 15.0,
            left: 15.0,
            right: 15.0,
          ),
          height: 350.0,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 10.0,
            shadowColor: Theme.of(context).primaryColor.withOpacity(0.2),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Select your last date of period?",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  tableCalendar,
                ]),
          ),
        );

    Column main() => Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              child: Image.asset(
                "assets/calendar.png",
                width: 48.0,
                height: 48.0,
              ),
            ),
            Text(
              "Predict cycle accurately.",
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Padding(padding: EdgeInsets.all(2.0)),
            Text(
              "Track period easily.",
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        );

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 5.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              main(),
              cycleLengthPicker(),
              datePicker(),
              PButton(
                text: "Submit",
                onPressed: this._predictCycle,
              )
            ],
          ),
        ),
      ),
    );
  }
}
