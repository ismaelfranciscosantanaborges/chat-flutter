import 'package:flutter/material.dart';

class ButtonBlue extends StatelessWidget {
  const ButtonBlue({
    Key key,
    @required this.onPressed,
    @required this.title,
  }) : super(key: key);

  final Function onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: this.onPressed,
      child: Container(
        width: double.infinity,
        height: 55,
        child: Center(
          child: Text(this.title ?? '', style: TextStyle(fontSize: 16)),
        ),
      ),
      shape: StadiumBorder(),
      color: Colors.blue,
      textColor: Colors.white,
      elevation: 3,
      highlightElevation: 5,
    );
  }
}
