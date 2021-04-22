import 'package:flutter/material.dart';

void showBottomModal(BuildContext context, Widget widget, {Function cb}) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          color: Theme.of(context).backgroundColor.withOpacity(0),
          child: Container(
            height: 170.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              color: Color(0xFFffffff),
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: widget,
            ),
          ),
        );
      }).then((value) {
    if (cb != null) cb(value);
  });
}
