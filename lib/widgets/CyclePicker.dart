import 'package:flutter/material.dart';
import 'package:carousel_select_widget/carousel_select_widget.dart';

class CyclePicker extends StatelessWidget {
  final Function onSelect;
  const CyclePicker({
    Key key,
    @required this.onSelect,
  }) : super(key: key);

  List<String> _getCycleLength() {
    List<String> cycleLength = [];
    for (int day = 11; day <= 45; day++) {
      cycleLength.add(day.toString());
    }
    return cycleLength;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: CarouselSelect(
          onChanged: this.onSelect,
          valueList: this._getCycleLength(),
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
          activeItemTextColor: Theme.of(context).primaryColor,
          passiveItemsTextColor:
              Theme.of(context).textTheme.bodyText1.color.withOpacity(0.2),
          initialPosition: 17,
          scrollDirection: ScrollDirection.horizontal,
          activeItemFontSize: 16.0,
          passiveItemFontSize: 16.0,
          height: 50.0,
        ),
      ),
    );
  }
}
