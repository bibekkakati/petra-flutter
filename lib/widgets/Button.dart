import 'package:flutter/material.dart';

class PButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  PButton({Key key, @required this.text, @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(this.text),
      onPressed: this.onPressed,
    );
  }
}

class OButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  OButton({
    Key key,
    @required this.text,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: Text(this.text),
      onPressed: this.onPressed,
    );
  }
}
