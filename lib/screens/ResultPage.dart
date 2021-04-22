import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:petra/models/Result.dart';
import 'package:petra/widgets/BottomModal.dart';
import 'package:petra/widgets/Button.dart';
import 'package:petra/widgets/MessageBar.dart';
import 'package:petra/widgets/TrackCycle.dart';
import 'package:table_calendar/table_calendar.dart';

class ResultPage extends StatefulWidget {
  final Result result;

  ResultPage({Key key, @required this.result}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  Result _result;

  DateTime _todaysDate,
      _firstDay,
      _lastDay,
      _focusedDay,
      _selectedDay,
      _rangeStartDay,
      _rangeEndDay;
  int _periodDay;
  String _currentPhase;
  bool _allowTracking, _loading = true;

  Map<String, String> _phases = {
    'MP': "Menstrual Phase",
    'OP': "Ovulation Phase",
    'FP': "Follicular Phase",
    'LP': "Luteal Phase"
  };

  void _showTips() {
    if (this._currentPhase == 'FP') {
      showBottomModal(
          context,
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text(
              "The focus of the diet should be on increasing iron-rich foods and vitamin B12. Some iron-rich foods include grass-fed beef or wild game, wild-caught fish such as salmon, and organic chicken. Additionally, including pasture-raised eggs during this period of the cycle can be very nourishing (always ensure pasture-raised variety for highest nutrient density).",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ));
      return;
    }
    if (this._currentPhase == 'OP') {
      showBottomModal(
          context,
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text(
              "Focus on fiber-rich veggies like asparagus, Brussels sprouts, chard, dandelion greens, okra, and spinach. Additionally, antioxidant-rich fruit such as raspberries, strawberries, coconut and guava help to increase glutathione and support further detoxification of rising hormones in the liver.",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ));
      return;
    }
    if (this._currentPhase == 'LP') {
      showBottomModal(
          context,
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text(
              "Focus on brown rice and millet as your grain choices in addition to protein from chickpeas, great northern beans, and navy beans or grass-fed beef and organic turkey. Lastly, sipping on peppermint tea at night or adding marine algae such as spirulina to smoothies can be great additions to help promote hormonal balance in this phase as well.",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ));
      return;
    }
    if (this._currentPhase == 'MP') {
      showBottomModal(
          context,
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text(
              "Foods that can help include water-rich fruits and vegetables that have an overall low glycemic index and are rich in iron, zinc, and iodine. Specifically, adzuki and kidney beans, kale, kelp, wakame, mushrooms, water chestnuts, beets, and watermelon can be very therapeutic.",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ));
      return;
    }
  }

  void _setRangePhase() {
    if (this._todaysDate.difference(this._result.nextPeriod).inDays >= 0) {
      _currentPhase = 'MP';
      _rangeStartDay = this._todaysDate;
      _rangeEndDay = this._todaysDate;
      setState(() {
        _loading = false;
      });
      return;
    }
    int diff = this._result.ovulationPhase.difference(this._todaysDate).inDays;
    if (diff >= -1 && diff <= 1) {
      _currentPhase = "OP";
      _rangeStartDay = this._result.ovulationPhase.subtract(Duration(days: 1));
      _rangeEndDay = this._result.ovulationPhase.add(Duration(days: 1));
    } else if (diff > 0) {
      _currentPhase = "FP";
      _rangeStartDay = this._result.lastPeriod;
      _rangeEndDay = this._result.ovulationPhase;
    } else {
      _currentPhase = "LP";
      _rangeStartDay = this._result.ovulationPhase;
      _rangeEndDay = this._result.nextPeriod;
    }
    setState(() {
      _loading = false;
    });
  }

  void _onTrackSuccess(dynamic value) {
    if (value == true) {
      setState(() {
        _allowTracking = false;
      });
      showMessageBar(context, "Started tracking.", error: false);
    } else if (value == false) {
      showMessageBar(context, "Something went wrong.", error: true);
    }
  }

  void _trackCycle() {
    showBottomModal(
      context,
      TrackCycle(
        result: this._result,
      ),
      cb: this._onTrackSuccess,
    );
  }

  @override
  void initState() {
    _result = widget.result;
    _todaysDate = DateTime.now();
    _periodDay = min(_todaysDate.difference(_result.lastPeriod).inDays + 2,
        _result.cycleLength);
    _firstDay = _result.lastPeriod;
    _lastDay = _result.nextPeriod.isAfter(_todaysDate) == true
        ? _result.nextPeriod
        : _todaysDate;
    _focusedDay = _todaysDate;
    _selectedDay = _result.nextPeriod;
    _allowTracking =
        this._result.id == null && _result.nextPeriod.isAfter(_todaysDate)
            ? true
            : false;
    this._setRangePhase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Container todayDate() => Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.date_range,
                size: 16.0,
                color: Theme.of(context).textTheme.headline6.color,
              ),
              Text(
                'Today, ' + DateFormat.MMMMd().format(this._todaysDate),
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        );

    Stack periodDay() => Stack(
          alignment: Alignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: Card(
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0),
                ),
                shadowColor: Theme.of(context).primaryColor.withOpacity(0.6),
                borderOnForeground: false,
                child: Container(
                  width: 130.0,
                  height: 130.0,
                  child: Center(
                    child: Text(
                      'Day $_periodDay',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                "assets/bg.png",
                width: 170.0,
                height: 170.0,
              ),
            ),
          ],
        );

    TableCalendar tableCalendar = TableCalendar(
      firstDay: this._firstDay,
      lastDay: this._lastDay,
      focusedDay: this._focusedDay,
      rangeStartDay: this._rangeStartDay,
      rangeSelectionMode: RangeSelectionMode.disabled,
      rangeEndDay: this._rangeEndDay,
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
        rangeStartDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).primaryColor.withOpacity(0.2),
        ),
        rangeEndDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).primaryColor.withOpacity(0.2),
        ),
        rangeHighlightColor: Theme.of(context).primaryColor.withOpacity(0.2),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: Theme.of(context).textTheme.bodyText1,
        weekendStyle: Theme.of(context).textTheme.bodyText1,
      ),
      availableGestures: AvailableGestures.horizontalSwipe,
      selectedDayPredicate: (day) => isSameDay(this._selectedDay, day),
      onPageChanged: (focusedDay) {},
    );

    Container periodCalendar() => Container(
          margin: EdgeInsets.only(
            top: 10.0,
            bottom: 15.0,
            left: 15.0,
            right: 15.0,
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 10.0,
            shadowColor: Theme.of(context).primaryColor.withOpacity(0.2),
            child: this._loading == true
                ? CircularProgressIndicator()
                : tableCalendar,
          ),
        );

    Container actionButtons() => this._allowTracking == true
        ? Container(
            margin: EdgeInsets.only(
              top: 10.0,
              bottom: 15.0,
            ),
            child: PButton(
              text: "Track Cycle",
              onPressed: this._trackCycle,
            ))
        : Container();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: todayDate(),
        toolbarHeight: 50.0,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: this._loading == true
                ? Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      periodDay(),
                      Container(
                        margin: EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              this._phases[this._currentPhase],
                            ),
                            GestureDetector(
                              onTap: this._showTips,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Icon(
                                  Icons.info_outline_rounded,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .color,
                                  size: 20.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      periodCalendar(),
                      Container(
                        child: Text(
                          'Period starts on ' +
                              DateFormat.MMMMd()
                                  .format(this._result.nextPeriod),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      actionButtons(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

// on app load.. check for past period and delete
